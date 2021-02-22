# mips-curve-area
MIPS Assembly Program for obtaining the area under a curve formed by joining successive points by a straight line.


Some Test cases: 

<table style="border: 1px solid black;" rules="all">
  <tr>
    <th>Type</th>
    <th>Number of points</th>
    <th>Points to give as input</th>
    <th>Area</th>
  </tr>
  <tr>
    <td rowspan="4">Basic (x>0, y>0, n>0)</td>
    <td>3</td>
    <td>(2, 2), (3, 3), (4, 4)</td>
    <td>6</td>
  </tr>
  <tr>
  	<td>4</td>
    <td>(1, 2), (3, 7), (4, 90), (10, 17)</td>
    <td>378.5</td>
  </tr>
  <tr>
  	<td>2</td>
    <td>(0, 2), (15, 0)</td>
    <td>15</td>
  </tr>
  <tr>
  	<td>1</td>
    <td>(1, 1)</td>
    <td>0</td>
  </tr>
  <tr>
    <td rowspan="1">Number of points < 1 </td>
    <td>0</td>
    <td> - </td>
    <td>error</td>
  </tr>
  <tr>
    <td rowspan="1">Number of points < 0 </td>
    <td>-1</td>
    <td> - </td>
    <td>error</td>
  </tr>
  <tr>
    <td rowspan="4">Below x axis</td>
    <td>3</td>
    <td>(2, -2), (3, -3), (4, -4)</td>
    <td>6</td>
  </tr>
  <tr>
    <td>3</td>
    <td>(2, -2), (3, 3), (4, 4)</td>
    <td>1.65</td>
  </tr>
  <tr>
    <td>3</td>
    <td>(2, 2), (3, -3), (4, 4)</td>
    <td>2.5142</td>
  </tr>
  <tr>
    <td>10</td>
    <td>(2, 2), (3, -3), (4, 4), (5, 0), (6, 0), (7, 0), (8, 0), (9, 0), (10, 0), (11, 0)</td>
    <td>4.5142</td>
  </tr>
</table>