extends Node

# Some helper functions to get an array of voronoi cells out of the Delaunator class

func next_half_edge(e):
	return e - 2 if e % 3 == 2 else e + 1

func edges_around_point(delaunay, start):
	var result = []
	var incoming = start
	while true:
		result.append(incoming);
		var outgoing = next_half_edge(incoming)
		incoming = delaunay.halfedges[outgoing];
		if not (incoming != -1 and incoming != start): break
	return result

func triangle_of_edge(e):
	return floor(e / 3)

func edges_of_triangle(t):
	return [3 * t, 3 * t + 1, 3 * t + 2]

func points_of_triangle(points, delaunay, t):
	var points_of_triangle = []
	for e in edges_of_triangle(t):
		points_of_triangle.append(points[delaunay.triangles[e]])
	return points_of_triangle

func circumcenter(a, b, c):
	var ad = a[0] * a[0] + a[1] * a[1]
	var bd = b[0] * b[0] + b[1] * b[1]
	var cd = c[0] * c[0] + c[1] * c[1]
	var D = 2 * (a[0] * (b[1] - c[1]) + b[0] * (c[1] - a[1]) + c[0] * (a[1] - b[1]))

	return [
		1 / D * (ad * (b[1] - c[1]) + bd * (c[1] - a[1]) + cd * (a[1] - b[1])),
		1 / D * (ad * (c[0] - b[0]) + bd * (a[0] - c[0]) + cd * (b[0] - a[0]))
	]

func centroid(a, b, c):
	var c_x = (a[0] + b[0] + c[0]) / 3
	var c_y = (a[1] + b[1] + c[1]) / 3

	return [c_x, c_y]

func incenter(a, b, c):
	var ab = sqrt(pow(a[0] - b[0], 2) + pow(b[1] - a[1], 2))
	var bc = sqrt(pow(b[0] - c[0], 2) + pow(c[1] - b[1], 2))
	var ac = sqrt(pow(a[0] - c[0], 2) + pow(c[1] - a[1], 2))
	var c_x = (ab * a[0] + bc * b[0] + ac * c[0]) / (ab + bc + ac)
	var c_y = (ab * a[1] + bc * b[1] + ac * c[1]) / (ab + bc + ac)

	return [c_x, c_y]

func triangle_center(points, delaunay, t, center = "circumcenter"):
	var vertices = points_of_triangle(points, delaunay, t)
	match center:
		"circumcenter": return circumcenter(vertices[0], vertices[1], vertices[2])
		"centroid": return centroid(vertices[0], vertices[1], vertices[2])
		"incenter": return incenter(vertices[0], vertices[1], vertices[2])

func get_voronoi_cells(points, delaunay) -> Array :
	var result : Array = []
	var seen = []
	for e in delaunay.triangles.size():
		var triangles = []
		var vertices = []
		var p = delaunay.triangles[next_half_edge(e)]
		if not seen.has(p):
			seen.append(p)
			var edges = edges_around_point(delaunay, e)
			for edge in edges:
				triangles.append(triangle_of_edge(edge))
			for t in triangles:
				vertices.append(triangle_center(points, delaunay, t))

		if triangles.size() > 2:
			var voronoi_cell = PoolVector2Array()
			for vertice in vertices:
				voronoi_cell.append(Vector2(vertice[0], vertice[1]))
			result.append(voronoi_cell)
	return result
