class ClientsController < ApplicationController
  def index
    @clients = Client.all
  end

  def create_by_csv
    path = "tmp/clients.csv"
    File.open path, "wb" do |f|
      f.puts params[:csv].read
    end
    Resque.enqueue ImportCsv, path
    redirect_to clients_path, notice: "enqueued."
  end

  def destroy
    @client = Client.find(params[:id])
    @client.destroy
    redirect_to clients_path
  end
end
