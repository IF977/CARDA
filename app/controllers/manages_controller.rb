class ManagesController < ApplicationController
  before_action :set_manage, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /manages
  # GET /manages.json
  def index
    @manages = Manage.all
  end

  # GET /manages/1
  # GET /manages/1.json
  def show
  end

  # GET /manages/new
  def new
    @manage = Manage.new
  end

  # GET /manages/1/edit
  def edit
  end

  # POST /manages
  # POST /manages.json
  def create
    @manage = Manage.new(manage_params)

    respond_to do |format|
      if @manage.save
        format.html { redirect_to @manage, notice: 'Prato criado com sucesso.' }
        format.json { render :show, status: :created, location: @manage }
      else
        format.html { render :new }
        format.json { render json: @manage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /manages/1
  # PATCH/PUT /manages/1.json
  def update
    respond_to do |format|
      if @manage.update(manage_params)
        format.html { redirect_to @manage, notice: 'Prato atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @manage }
      else
        format.html { render :edit }
        format.json { render json: @manage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manages/1
  # DELETE /manages/1.json
  def destroy
    @manage.destroy
    respond_to do |format|
      format.html { redirect_to manages_url, notice: 'Prato deletado com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manage
      @manage = Manage.find(params[:id])
    end
    
    # Adicionar picturem.
    def add_more_pictures(new_picture)
      pictures = @manage.pictures # copy the old pictures 
      pictures += new_pictures # concat old pictures with new ones
      @manage.pictures = pictures # assign back
    end
    
    
    

    # Never trust parameters from the scary internet, only allow the white list through.
    def manage_params
      params.require(:manage).permit(:name, :price, :ingredient, {pictures: []})
    end
end
