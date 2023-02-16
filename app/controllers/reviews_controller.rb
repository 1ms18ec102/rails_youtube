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
                    turbo_stream.append("comment_form" ,partial: "reviews/showcomments", locals: { friend: @review  })
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

    private

    def get_friend
        @friend = Friend.find(params[:friend_id])
    end

    def review_params
        params.require(:review).permit(:rtext)
    end

end