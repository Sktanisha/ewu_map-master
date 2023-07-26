// class Node {
//   int x;
//   int y;
//   int cost;
//   Node? parent;

//   Node(this.x, this.y, this.cost, this.parent);
// }

// void ucs(List<List<int>> grid, int startX, int startY, int endX, int endY) {
//   List<Node> open = [];
//   open.add(Node(startX, startY, 0, null));

//   while (open.isNotEmpty) {
//     Node current = open.removeAt(0);

//     if (current.x == endX && current.y == endY) {
//       print("Found path!");
      
//       return;
//     }

//     for (int x = current.x - 1; x <= current.x + 1; x++) {
//       for (int y = current.y - 1; y <= current.y + 1; y++) {
//         if (x >= 0 && x < grid.length && y >= 0 && y < grid[0].length && grid[x][y] != 1) {
//           Node neighbor = Node(x, y, current.cost + 1, current);
//           if (!open.contains(neighbor)) {
//             open.add(neighbor);
//           }
//         }
//       }
//     }
//   }

//   print("No path found!");
// }

// void main() {
//   List<List<int>> grid = [
//     [0, 0, 0, 0, 0],
//     [0, 1, 0, 0, 0],
//     [0, 0, 0, 1, 0],
//     [0, 0, 0, 0, 1],
//     [0, 0, 0, 0, 0],
//   ];

//   ucs(grid, 0, 0, 4, 4);
// }