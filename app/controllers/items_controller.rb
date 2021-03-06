class ItemsController < ApplicationController
  before_action :move_to_index, except: [:index, :show]
  before_action :item_deta, only: [:edit, :update, :destroy, :show]


  def new
    @item = Item.new
    @item.images.new
    @category_parent_array = Category.where(ancestry: nil) 
  end

  def get_category_children
    @category_children = Category.find("#{params[:parent_id]}").children    
  end

  def get_category_grandchildren
    @category_grandchildren = Category.find("#{params[:child_id]}").children
  end


  def create
    @item = Item.new(item_params)
    @category_parent_array = Category.where(ancestry: nil) 
    if @item.save
        redirect_to root_path, notice: "出品が完了しました"
    else
      redirect_to new_item_path
      flash.now[:alert] = "商品出品に失敗しました"
    end
  end

  def edit
    @category_parent_array = Category.where(ancestry: nil) 
  end

  def update
    if @item.update(item_params)
      redirect_to item_path(@item), notice: "商品の編集が完了しました"
    else
      redirect_to edit_item_path(@item), notice: "必須項目を入力してください"
    end
  end

  def destroy
    @item.destroy
    redirect_to root_path
  end

  def show
    # 商品出品者のidを入れる
    @user = @item.user
    @category_grandchild = @item.category
    @category_child = @category_grandchild.parent
    @category_parent = @category_child.parent
    @category_brand = @item.brand
    @category_status = @item.item_status
    @handling_time = @item.handling_time
    @prefecture = @item.prefecture
    @description = @item.description
    @price = @item.price
  end



  private

  def item_deta
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit( :name, :description, :category_id, :brand, :item_status_id, :shipping_charge_id,:prefecture_id , :handling_time_id,:price, images_attributes: [:image, :id, :_destroy]).merge(user_id: current_user.id)
  end

  def move_to_index
    redirect_to action: :index unless user_signed_in?
  end

end
