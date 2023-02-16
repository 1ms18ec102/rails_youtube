class ReviewsController < ApplicationController
    before_action :get_friend

    def new
        @review=@friend.reviews.build
    end

    def index
        @reviews = @friend.reviews.all
    end
    
    def create
        @review=@friend.reviews.build(review_params)
        respond_to do |format|
            if @review.save
              format.turbo_stream do
                render turbo_stream: [
                    turbo_stream.update("comment_form" ,partial: "reviews/form", locals: { review: @friend }),
                    turbo_stream.update("comments_show" ,partial: "reviews/showcomments", locals: { friend: @review  })
                ]
              end
              format.html { redirect_to friend_path(@friend), notice: "comment was successfully created." }
              format.json { render :show, status: :created, location: @review }
            else
              format.turbo_stream do
                    render turbo_stream: [
                        turbo_stream.update("comment_form" ,partial: "reviews/form", locals: { review: @review })
                    ]
                  end  
              format.html { render :new, status: :unprocessable_entity }
              format.json { render json: @review.errors, status: :unprocessable_entity }
            end
          end
    end

    def show
        @review = @friend.reviews.find(params[:id])
    end

    def destroy
        @review = @friend.reviews.find(params[:id])
        respond_to do |format|
            if @friend.user_id==current_user.id
                if @review.destroy
                    format.turbo_stream do
                        render turbo_stream: [
                           
                            turbo_stream.update("comments_show" ,partial: "reviews/showcomments", locals: { friend: @review  })
                        ]
                    end
                    format.html { redirect_to friend_path(@friend), notice: 'Comment was successfully destroyed.' }
                    format.json { head :no_content }
                    
                else
                    format.turbo_stream do
                        render turbo_stream: [
                            turbo_stream.update("comment_form" ,partial: "reviews/form", locals: { review: @review })
                        ]
                    end
                    format.html { render :new, status: :unprocessable_entity }
                    format.json { render json: @review.errors, status: :unprocessable_entity }
                end
            else
                format.turbo_stream do
                    render turbo_stream: [
                        turbo_stream.update("comments_show" ,partial: "reviews/showcomments", locals: { review: @review } ,notice: 'you are not the right user to destory it.' )
                    ]
                end
                format.html { redirect_to friend_path(@friend), notice: 'you are not the right user to destory it.' }
                format.json { head :no_content }
                
            end
        end
    end

    private

    def get_friend
        @friend = Friend.find(params[:friend_id])
    end

    def review_params
        params.require(:review).permit(:rtext)
    end

end