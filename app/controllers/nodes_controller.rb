class NodesController < ApplicationController
  before_action :check_common_ancestor_params, only: :common_ancestor
  before_action :check_birds_params, only: :birds

  def common_ancestor
    node1 = Node.find_by(id: params[:a])
    node2 = Node.find_by(id: params[:b])

    begin
      lowest_common_ancestor = NodesHelper.find_lowest_common_ancestor!(node1, node2)
      root, depth = NodesHelper.find_root_and_depth!(lowest_common_ancestor)
      
      render :json => {root_id: root&.id, lowest_common_ancestor: lowest_common_ancestor&.id, depth: depth.zero? ? nil : depth}
    rescue StandardError => e
      render :json => {error: e.message}
      return
    end
    
  end

  def birds
    node_ids = params[:node_ids].split(',')
    result = []
    
    node_ids.each do |node_id|
      node = Node.includes(:birds).find_by(id: node_id)

      if node.present?
        begin
          bird_ids = NodesHelper.get_bird_ids_for_node_and_descendants!(node)
          result << {node_id: node.id, bird_ids: bird_ids}
        rescue StandardError => e
          result << {node_id: node.id, error: e.message, bird_ids: nil}
        end
      end
    end

    render :json => result
  end

  private

  def check_common_ancestor_params
    unless params[:a].present? && params[:b].present?
      render json: { error: "Both a and b are required" }, status: :unprocessable_entity
    end
  end


  def check_birds_params
    unless params[:node_ids]
      render json: { error: "node_ids are required" }, status: :unprocessable_entity
    end
  end
end
