class BookCommentsController < ApplicationController

  def create
    book = Book.find(params[:book_id])
    book_comment = book.book_comments.build(book_comment_params)
    book_comment.user_id = current_user.id
    book_comment.save
    @book_comments = book.book_comments
    render :index
  end

  def destroy
    book_comment = BookComment.find(params[:id])
    @book_comments = book_comment.book.book_comments
    book_comment.destroy
    render :index
  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:comment, :book_id, :user_id)
  end
end
