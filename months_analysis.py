"""
    Rae Adimer
    
    Calculates statistics on annual ordered lists of months by active editor count:
    - Kendall tau distances (between each year and the manually-entered seasonal dummies estimate)
    - Chart of each month's placement by year
    - Mean/standard deviation of each month's placement distribution
"""

def parse_data(file_name):
    # Opens the specified file and returns the data as a dictionary
    data = {}
    with open(file_name, 'r') as file: 
        line_counter = 0
        for line in file:
            if line_counter == 0:
                line_counter += 1
            else:
                year, January, February, March, April, May, June, July, August, September, October, November, December = line.split(',')
                data[str(year)] = [January, February, March, April, May, June, July, August, September, October, November, December[:-1]]
    return data

def gen_ordered_lists(data):
    # Takes the data dictionary and returns a second dictionary of ordered lists. (each month is its name)
    ordered_lists = {}
    months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
    for year, editors_per_month in data.items():
        sorted_indexes = sorted(range(len(editors_per_month)), key=lambda i: editors_per_month[i], reverse=True)
        ordered_months = [months[i] for i in sorted_indexes]
        ordered_lists[year] = ordered_months
    numbered_lists = {}
    for year, editors_per_month in data.items():
        sorted_indexes = sorted(range(len(editors_per_month)), key=lambda i: editors_per_month[i], reverse=True)
        numbered_lists[year] = [i+1 for i in sorted_indexes]
    return ordered_lists, numbered_lists

def kendall_tau(order):
    # Compares a year's list with the estimated list (below) and returns the kendall tau distance
    estimated = ['March', 'April', 'January', 'October', 'May', 'November', 'February', 'September', 'December', 'August', 'July', 'June']
    counter = 0
    already_checked = []
    for estimate in estimated:
        for actual in order:
            if actual != estimate and (actual, estimate) not in already_checked and (estimate, actual) not in already_checked:
                rel_est = 0
                rel_act = 0
                if estimated.index(actual) > estimated.index(estimate):
                    rel_est = 1
                else:
                    rel_est = 0
                if order.index(actual) > order.index(estimate):
                    rel_act = 1
                else:
                    rel_act = 0
                if rel_est != rel_act:
                    counter += 1
                already_checked.append((estimate, actual))
    return counter

def output_kendall_tau(distances):
    # Outputs kendall tau distances
    file_name = str(input('Output file name for Kendall tau (no file type): ') + '.csv')
    with open(file_name, 'w') as file:
        file.write('Year,Distance\n')
        for n in distances:
            file.write(f'{n},{distances[n]},\n')
    return

def output_months_table(ordered):
    # Outputs the table of months' annual ordering
    file_name = str(input('Output file name for yearly charts (no file type): ') + '.csv')
    with open(file_name, 'w') as file:
        file.write('Year,1,2,3,4,5,6,7,8,9,10,11,12\n')
        for n in ordered:
            file.write(f'{n},{ordered[n][0]},{ordered[n][1]},{ordered[n][2]},{ordered[n][3]},{ordered[n][4]},{ordered[n][5]},{ordered[n][6]},{ordered[n][7]},{ordered[n][8]},{ordered[n][9]},{ordered[n][10]},{ordered[n][11]},\n')
    return

def output_months_stats(numbered):
    # Calculates and outputs each month's mean placement and standard deviation
    order = ['january', 'february', 'march', 'april', 'may', 'june', 'july', 'august', 'september', 'october', 'november', 'december']
    months = {}
    for n in order:
        months[n] = []
    for i in numbered:
        for n in numbered[i]:
            months[order[n - 1]].append(numbered[i].index(n) + 1)
    month_stats = {}
    for n in order:
        month_stats[n] = [0, 0] # average, stddev
    # Averages
    for n in order:
        month_stats[n][0] = f'{(sum(months[n]) / len(months[n])):.2f}'
    # Standard deviation
    for n in order:
        month_stats[n][1] = std_dev(months[n])
    file_name = str(input('Output file name for month stats (no file type): ') + '.csv')
    with open(file_name, 'w') as file:
        file.write('Month,Mean,Standard deviation\n')
        for n in month_stats:
            file.write(f'{n},{month_stats[n][0]},{month_stats[n][1]}\n')
    return

def std_dev(lst1):
    # Calculates standard deviation of a distribution
    count = len(lst1)
    total = sum(lst1)
    mean = total / count
    errors = []
    for i in lst1:
        indiv_error = (i - mean) ** 2
        errors.append(indiv_error)
    sum_errors = sum(errors)
    inside_eq = sum_errors / (count - 1)
    stddev = (inside_eq)**(0.5)
    return f'{stddev: .2f}'

def main():
    file_name = str(input('Name of the file: '))
    try:
        data = parse_data(file_name)
    except:
        print('Problem opening or parsing file.')
        return
    ordered, numbered = gen_ordered_lists(data)
    distances = {}
    for n in ordered:
        distances[n] = kendall_tau(ordered[n])
    output_kendall_tau(distances)
    output_months_table(ordered)
    output_months_stats(numbered)

if __name__ == "__main__":
    main()