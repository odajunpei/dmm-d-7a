class BooksController < ApplicationController

  def create
      @book = Book.new(book_params)
      @book.user_id = current_user.id
      if @book.save
        redirect_to book_path(@book), notice: 'You have created book successfully.'
      else
        @user = current_user
        @books = Book.all
        render :index
      end
  end

  def index
    to = Time.current.at_end_of_day
    from  = (to - 6.day).at_beginning_of_day
    books = Book.includes(:favorited_users).
      sort {|a,b|
        b.favorited_users.includes(:favorites).where(created_at: from...to).size <=>
        a.favorited_users.includes(:favorites).where(created_at: from...to).size
      }
    @books = Kaminari.paginate_array(books).page(params[:page]).per(8)
    @user = current_user
    @book = Book.new
  end


  def edit
    @book = Book.find(params[:id])
    if @book.user == current_user
      render :edit
    else
      redirect_to books_path
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path, notice: 'Book was successfully destroyed.'
  end

  def show
    @book_find = Book.find(params[:id])
    @user = @book_find.user
    @book = Book.new
    @users = User.all
    @book_comment = BookComment.new
    @book_comments = @book_find.book_comments
  end

 def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book.id), notice: 'You have updated book successfully.'
    else
      render :edit
    end
 end

  private

    def book_params
    params.require(:book).permit(:title, :body)
    end

end
