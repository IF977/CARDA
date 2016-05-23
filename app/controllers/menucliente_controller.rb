class MenuclienteController < ApplicationController
#    before_action :passvalue, only: [:lista]
    
    $seq_ped = 0
    
    def pratos
       @escolha_ped = Manage.all
    end
    
    # GET /menucliente/1
    # GET /menucliente/1.json
    def show
        @mostra = Manage.find(params[:id])
    end
    
    def list
        @list_comp = List.new
        @mostra = Manage.find(params[:id])
        @list_comp.qtd = params[:qtds]
        @list_comp.total = (params[:qtds]).to_i * (@mostra.price).to_i
        @list_comp.manage_id = params[:id]
        @list_comp.namep = @mostra.name
        @list_comp.price = @mostra.price
        $mesa = @list_comp.mesa_n = params[:mesa]
        @list_comp.save

        redirect_to lista_menucliente_path
    end
    
    def lista
        @list_compx = List.where(mesa_n: $mesa)
    end
    
    def limplista
        @list_compx = List.where(mesa_n: $mesa)
        @list_compx.each do |x|
            x.destroy
        end
        redirect_to lista_menucliente_path
    end
    
    def destroy
        @del = List.find(params[:id])
        @del.destroy
        respond_to do |format|
            format.html { redirect_to lista_menucliente_path, notice: 'Item deletado com sucesso.' }
            format.json { head :no_content }
        end
    end
    
    def apaga_ped
        
        @del = Order.find(params[:id])
        @tempo = ((@del.created_at + 1800)-(Time.now))/60
        if @tempo > 27
            @del.destroy
            respond_to do |format|
                format.html { redirect_to pedidos_menucliente_index_path, notice: 'Pedido cancelado!' }
                format.json { head :no_content }
            end
        else
            respond_to do |format|
                format.html { redirect_to pedidos_menucliente_index_path, notice: 'O pedido não foi cancelado devido ja terem passados 3 minutos da solicitação. Deseja chamar o Garçom para continuar com o cancelamento!' }
                format.json { head :no_content }
            end
        end
    end
    
    def pedid_save
        @soma = 0
        @list_price = List.where(mesa_n: $mesa)
        @list_price.each do |k|
            @soma += (k.price).to_i
        end
        if @soma > 0
            @ped = Order.new
            @ped.n_order = (((Time.now) -10800).strftime("%Y%m")).to_i * 10000 + $seq_ped
            $seq_ped += 1
            @ped.n_table = params[:mesa]
            @ped.price = @soma
            #@ped.price = "select sum(List.total) from Lists where(mesa_n: params[:mesa]);"
            #@ped.price = List.where(mesa_n: params[:mesa]).sum(:total) #.where(mesa_n: params[:mesa])
            @list_price.each do |tk|
                @List_order = OrderListDef.new
                @List_order.namep = tk.namep
                @List_order.qtd = tk.qtd
                @List_order.prato_price = tk.price
                @List_order.total = tk.total
                @List_order.manage_id = tk.id
                @List_order.mesa_n = @ped.n_table
                @List_order.n_order = @ped.n_order
                @List_order.pedido_total_price = @ped.price
                @List_order.status = 1
                @List_order.save
            end
            @ped.save
            @list_price.each do |k|
                k.destroy
            end
            redirect_to pedidos_menucliente_index_path
        else
            respond_to do |format|
                format.html { redirect_to lista_menucliente_path, notice: 'Pedido não realizado, pois nenhum prato foi escolhido!' }
                format.json { head :no_content }
            end
        end
    end
    
    def pedidos
        @lista_ped = Order.where(n_table: $mesa)
    end
    
    def conta
        @lista_ped = OrderListDef.where(mesa_n: $mesa)
        #@lista_prato = List.where(mesa_n: $mesa)
        
    end
    
    private
        
        def list_params
            params.require(:list).permit(:id, :namep, :qtd, :price, :total)
        end
    
end

    