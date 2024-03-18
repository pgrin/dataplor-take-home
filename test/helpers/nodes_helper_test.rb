require "test_helper"

class NodesHelperTest < ActiveSupport::TestCase
  setup do
    Node.create!(id: 125, parent_id: 130)
    Node.create(id: 130)
    Node.create(id: 2820230, parent_id: 125)
    Node.create(id: 4430546, parent_id: 125)
    Node.create(id: 5497637, parent_id: 4430546)
  end
  
  test "find lowest common ancestor happy path" do
    node1 = Node.find(5497637)
    node2 = Node.find(2820230)
    lca = NodesHelper.find_lowest_common_ancestor!(node1, node2)
    assert_equal 125, lca.id

    node1 = Node.find(5497637)
    node2 = Node.find(130)
    lca = NodesHelper.find_lowest_common_ancestor!(node1, node2)
    assert_equal 130, lca.id

    node1 = Node.find(5497637)
    node2 = Node.find(4430546)
    lca = NodesHelper.find_lowest_common_ancestor!(node1, node2)
    assert_equal 4430546, lca.id
  end

  test "find lowest common ancestor with no match" do
    node1 = nil
    node2 = Node.find(2820230)
    lca = NodesHelper.find_lowest_common_ancestor!(node1, node2)
    assert_nil lca
  end

  test "find lowest common ancestor same node" do
    node1 = Node.find(2820230)
    node2 = node1
    lca = NodesHelper.find_lowest_common_ancestor!(node1, node2)
    assert_equal node1, lca
  end

  test "find lowest common ancestor with a cycle" do
    node1 = Node.create(id: 1, parent_id: 2)
    node2 = Node.create(id: 2, parent_id: 1)
    
    assert_raises(StandardError) do
      NodesHelper.find_lowest_common_ancestor!(node1, node2)
    end
  end

  test "find root and depth happy path" do
    expected_root = Node.find(130)

    node = Node.find(5497637)
    root, depth = NodesHelper.find_root_and_depth!(node)

    assert_equal expected_root, root
    assert_equal 4, depth

    node = Node.find(4430546)
    root, depth = NodesHelper.find_root_and_depth!(node)

    assert_equal expected_root, root
    assert_equal 3, depth

    node = Node.find(130)
    root, depth = NodesHelper.find_root_and_depth!(node)

    assert_equal expected_root, root
    assert_equal 1, depth
  end

  test "find root and depth nil node" do
    root, depth = NodesHelper.find_root_and_depth!(nil)

    assert_nil root
    assert_equal 0, depth
  end


  test "find root and depth with a cycle" do
    node1 = Node.create(id: 1, parent_id: 2)
    node2 = Node.create(id: 2, parent_id: 1)

    assert_raises(StandardError) do
      NodesHelper.find_root_and_depth!(node)
    end
  end

  test "get_bird_ids_for_node_and_descendants happy path" do
    node1 = Node.first
    node1.birds.create!
    node1.birds.create!

    node1.children[0].birds.create!

    bird_ids = NodesHelper.get_bird_ids_for_node_and_descendants!(node1)

    assert_equal 3, bird_ids.length
  end

  test "get_bird_ids_for_node_and_descendants cycle detected" do
    node1 = Node.create(id: 1, parent_id: 2)
    node2 = Node.create(id: 2, parent_id: 1)

    assert_raises(StandardError) do
      NodesHelper.get_bird_ids_for_node_and_descendants!(node1)
    end
  end
end
