def compare_numbers():
    try:
        num1 = float(input("Введите первое число: "))
        num2 = float(input("Введите второе число: "))

        if num1 > num2:
            print(f"{num1} больше {num2}.")
        elif num1 < num2:
            print(f"{num1} меньше {num2}.")
        else:
            print("Оба числа равны.")
    except ValueError:
        print("Ошибка: Введите корректные числовые значения.")

compare_numbers()


def divide_numbers():
    try:
        num1 = float(input("Введите делимое: "))
        num2 = float(input("Введите делитель: "))

        result = num1 / num2
        print(f"Результат деления: {result}")
    except ZeroDivisionError:
        print("Ошибка: Деление на ноль невозможно.")
    except ValueError:
        print("Ошибка: Введите корректные числовые значения.")

divide_numbers()
