module NodesHelper
    def self.find_lowest_common_ancestor!(node1, node2)
        # a set to hold all the ancestors starting with node1 (including node1)
        ancestors = Set.new
        # a set to hold all the visited nodes to detect cycles
        visited = Set.new
        current = node1

        # traverse up the tree until parent the root, add to the ancestor set as we go
        while current.present?
            raise "invalid tree" if visited.include?(current)
            visited << current
                
            ancestors << current.id
            current = current.parent
        end
  
        lowest_common_ancestor = nil
        visited = Set.new # reset visited set
        current = node2
        
        # traverse up the tree until we hit the root 
        # if current node is in the ancestors set, that's the lowest common ancestor
        while current.present?
            raise "invalid tree" if visited.include?(current)
            visited << current

            if ancestors.include?(current.id)
                lowest_common_ancestor = current
                break
            end

            current = current.parent
        end


        return lowest_common_ancestor
    end

    def self.find_root_and_depth!(node)
        depth = 0
        last = nil

        # a set to hold all the visited nodes to detect cycles
        visited = Set.new

        while node.present?
            raise "invalid tree" if visited.include?(node)
            visited << node

            depth +=1
            last = node
            node = node.parent
        end

        return last, depth
    end

    def self.get_bird_ids_for_node_and_descendants!(node)
        ret = []

        # a queue for BFS
        queue = [node]

        # a set to detect cycles
        visited = Set.new

        while !queue.empty?
            current = queue.shift
            
            raise "invalid tree" if visited.include?(current)
            visited << current

            # get all the bird ids
            bird_ids = current.birds.pluck(:id)

            ret.concat(bird_ids) if !bird_ids.empty?

            # add childred to queue
            current.children.each do |child|
                queue << child
            end
        end

        ret
    end
end
