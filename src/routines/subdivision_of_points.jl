using Oscar

function subdivision_of_points_workaround(points::Matrix{Int}, weights::Vector)
    indices = findall(!iszero, weights)

    relevant_points = points[indices, :]
    relevant_weights = QQ.(weights[indices]; preserve_ordering=true)

    return subdivision_of_points(relevant_points, relevant_weights)



end