# Main-Script
# #############################################################################

# This python script is the main script for the third exercise of the lecture.
# It contains the Kriging interpolation for the given points and the new point N

# Author:
# Christopher Mahn

# #############################################################################

# Import of Libraries
# -----------------------------------------------------------------------------

import numpy as np
import matplotlib.pyplot as plt

# -----------------------------------------------------------------------------
# Settings and Parameters

matrikelnumber = "0000080"  # Your matrikelnumber

points = {"1": {"easting": 3.0, "northing": 4.0, "elevation": 120.0},  # Given points
          "2": {"easting": 6.3, "northing": 3.4, "elevation": 103.0},
          "3": {"easting": 2.0, "northing": 1.3, "elevation": 142.0},
          "4": {"easting": 3.8, "northing": 2.4, "elevation": 115.0},
          "5": {"easting": 1.0, "northing": 3.0, "elevation": 118.0},
          "N": {"easting": None, "northing": 3.0, "elevation": None}}

match int(matrikelnumber[-2]):  # Switch-Case for the second last digit of the matrikelnumber
    case 1:
        points["N"]["easting"] = 2.0
    case 4:
        points["N"]["easting"] = 2.0
    case 7:
        points["N"]["easting"] = 2.0
    case 2:
        points["N"]["easting"] = 3.0
    case 8:
        points["N"]["easting"] = 3.0
    case 9:
        points["N"]["easting"] = 3.0
    case _:
        points["N"]["easting"] = 4.0

num_points = len(points)-1  # Number of points without the point N


# Functions
# -----------------------------------------------------------------------------

def get_distance(point1, point2):
    """Calculates the 2d distance between two points.

    Args:
        point1 (dict): Dictionary with keys "easting" and "northing"
        point2 (dict): Dictionary with keys "easting" and "northing"

    Returns:
        float: Distance between the two points
    """
    return np.sqrt((point1["easting"] - point2["easting"]) ** 2 +
                   (point1["northing"] - point2["northing"]) ** 2)


def get_elevation(point1, point2):
    """Calculates the elevation difference between two points.

    Args:
        point1 (dict): Dictionary with key "elevation"
        point2 (dict): Dictionary with key "elevation"

    Returns:
        float: Elevation difference between the two points
    """
    return point1["elevation"] - point2["elevation"]


def plot_results(datasets, title_label, x_label, y_label, data_label, timestamps=None, save=False, plot_styles=["-"]):
    """
    This function plots graphs.

    Args:
        datasets ([[float]]): A list with datasets a lists with floating-point
        
                              numbers
        title_label (str): This is the tile of the plot
        x_label (str): This is the label of the x-axis
        y_label (str): This is the label of the y-axis
        data_label ([str]): This is a list with labels of the datasets
        timestamps ([float], optional): By using a list of floating-point
                                        numbers the data get's plotted on a
                                        time-axis. If nothing is provided the
                                        values will be plotted equidistant.
        save (bool, optional): If this is set to True the plot will be saved as
                               a png-file. If this is set to False the plot
                               will be shown in a new window. Defaults to False.
        plot_styles ([str], optional): This is a list with the plot-styles of
                                       the datasets. Defaults to ["-"].
    """
    for i, dataset in enumerate(datasets):
        if(timestamps==None):
            timestamps = range(len(dataset))
        plt.plot(timestamps, dataset, plot_styles[i])
    plt.legend(data_label)
    plt.grid()
    plt.xlabel(x_label)
    plt.ylabel(y_label)
    plt.title(title_label)
    if(save):
        plt.savefig(title_label + ".png")
    else:
        plt.show()


def linear_regression(x, y):
    """
    This function calculates the linear regression of two datasets.

    Args:
        x ([float]): A list with floating-point numbers
        y ([float]): A list with floating-point numbers
    
    Returns:
        float: The slope of the linear regression
        float: The y-intercept of the linear regression
    """
    x = np.array(x)
    y = np.array(y)
    m = (len(x) * np.sum(x*y) - np.sum(x) * np.sum(y)) / (len(x)*np.sum(x*x) - np.sum(x) ** 2)
    b = (np.sum(y) - m *np.sum(x)) / len(x)
    return(m, b)


# Classes
# -----------------------------------------------------------------------------

# Beginning of the Programm
# -----------------------------------------------------------------------------

if __name__ == '__main__':

    # Calculating the values for the Empirical semi-variogram
    distances = []
    semi_variance = []
    for i in range(1, num_points+1):
        for j in range(i + 1, num_points+1):
            distances.append(get_distance(points[str(i)], points[str(j)]))
            semi_variance.append((get_elevation(points[str(i)], points[str(j)])**2)/2)

    # Plotting the Empirical semi-variogram
    plot_results([semi_variance],
                 "Empirical semi-variogram",
                 "Distance",
                 "Semi-Variance",
                 ["Values"],
                 timestamps=distances,
                 save=False,
                 plot_styles=["o"])
    
    # Summarizing the Empirical semi-variogram
    sum_emp_semi_var = 0
    for i in range(1, num_points):
            sum_emp_semi_var += (get_elevation(points[str(i)], points[str(i+1)])**2)
    sum_emp_semi_var += (get_elevation(points[str(1)], points[str(num_points)])**2)
    sum_emp_semi_var = sum_emp_semi_var/(2*num_points)
    print(f'The Empirical semi-variogram is: {sum_emp_semi_var}')

    # Calculating the values for the Theoretical semi-variogram
    slope, y_intercept = linear_regression(distances, semi_variance)
    print(f'The slope of the linear regression is: {slope}')
    print(f'The y-intercept of the linear regression is: {y_intercept}')
    theoretical_semi_var = []
    for i in distances:
        theoretical_semi_var.append(slope * i + y_intercept)
    
    # Plotting the Theoretical semi-variogram
    plot_results([theoretical_semi_var],
                  "Theoretical semi-variogram",
                  "Distance",
                  "Semi-Variance",
                  ["Values"],
                  timestamps=distances,
                  save=False,
                  plot_styles=["o"])

    # Plotting both empirical and theoretical semi-variogram
    plot_results([semi_variance, theoretical_semi_var],
                 "Empirical and Theoretical semi-variogram",
                 "Distance",
                 "Semi-Variance",
                 ["Empirical", "Theoretical"],
                 timestamps=distances,
                 save=False,
                 plot_styles=["o", "-"])
    
    # Calculating the semi-variances and distances to N
    distances_to_n = []
    semi_var_to_n = []
    for i in range(1, num_points+1):
        distances_to_n.append(get_distance(points["N"], points[str(i)]))
        semi_var_to_n.append(slope * distances_to_n[-1] + y_intercept)
    print(f'The distances to N are: {distances_to_n}')
    print(f'The semi-variances to N are: {semi_var_to_n}')

    # Creating g-vector
    g_vector = semi_var_to_n
    g_vector.append(1)
    g_vector = np.array(g_vector)
    print(f'The g-vector is:\n{g_vector}')

    # Creating a-matrix
    a_matrix = np.zeros((num_points+1, num_points+1))
    for i in range(0, num_points):
        a_matrix[i][-1] = 1
        a_matrix[-1][i] = 1
    for i in range(0, num_points):
        for j in range(0, num_points):
            a_matrix[i][j] = slope * get_distance(points[str(i+1)], points[str(j+1)]) + y_intercept
    print(f'The a-matrix is:\n{a_matrix}')

    # Calcilating the weights, the sum of the weights and the lagrange multiplier
    weights = np.linalg.inv(a_matrix) @ g_vector
    lagrange_multiplier = weights[-1]
    weights = weights[0:num_points].tolist()
    weights_sum = np.sum(weights)
    print(f'The weights are:\n{weights}')
    print(f'The sum of the weights is: {weights_sum}')
    print(f'The lagrange multiplier is: {lagrange_multiplier}')

    # Calculating the theoretical elevation of Na_matrix @ weights
    n_theoretical_elevation = 0
    for i in range(0, num_points):
        n_theoretical_elevation += weights[i] * points[str(i+1)]["elevation"]
    print(f'The theoretical elevation of N is: {n_theoretical_elevation}')

    # Calculating the standard deviation of the theoretical elevation of N
    n_theoretical_elevation_var = np.transpose(np.append(weights, lagrange_multiplier)) @ g_vector
    n_theoretical_elevation_std = np.sqrt(n_theoretical_elevation_var)
    print(f'The variance of the theoretical elevation of N is: {n_theoretical_elevation_var}')
    print(f'The standard deviation of the theoretical elevation of N is: {n_theoretical_elevation_std}')