# README

To run the suite `rails s`

To run tests `rails t`

To load seeds `rails db:seed`

There is on controller nodes_controller.rb which has 2 actions: `common_ancestors` and `birds`

## Routes
### Lowest common ancestors

Step1: Start with node1 and create a set of all it's ancestors leading up to it's root
Step2: Then start with node2 and move up the tree, check each ancestors against the set from step 1. If you find the ancestor in the set that's the lowest common ancestor. return it.
Step3: Run up the tree from the LCA to the root, and count the depth

Caveat: There might be an invalid tree in the data, meaning there are cycles, where a child is also an ancestor of the same node. To deal with this issue, when traversing the tree keep a visited set, and check that you havent visited a node prior. If so, return an error, since this is an invalid tree.

There is a helper module `nodes_helper.rb` which breaks out these steps clearly

### Birds

Given a node, perform a BFS down the tree and collect all the birds from all the descendants of the node. Again watch out for invalid trees with a visited set, when traversing.

If invalid tree is found, return error.

`get_bird_ids_for_node_and_descendants` in the `nodes_helper.rb` performs this action


## Tests

`nodes_helper_test.rb` runs through various happy paths and edge cases



