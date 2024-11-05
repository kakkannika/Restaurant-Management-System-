// main.dart

import 'dart:io';
import 'Menu.dart';
import 'Order.dart';
import 'Table_reservation.dart';
import 'Enum.dart';
import 'Customer.dart';

void main() {
  bool continueProgram = true;

  // Initialize sample data
  var customer1 = Customer('C001', 'Kannika Kak', '010727093');
  Menu.menuItems = [
    Menu(201, 'Sandwich', 5, 200, ProductType.food),
    Menu(204, 'Dessert', 2, 150, ProductType.desserts),
    Menu(205, 'Pizza', 10, 15.5, ProductType.food)
  ];

  do {
    print('\n=== Restaurant Management System ===');
    print('1. Display the Menu');
    print('2. Add item to Menu');
    print('3. Remove item from Menu');
    print('4. Add Order');
    print('5. Make Reservation');
    print('6. Display Customer Details');
    print('0. Exit');
    print('Please enter your choice: ');

    String? choice = stdin.readLineSync();
    switch (choice) {
      case '1':
        Menu.displayMenu();
        break;

      case '2':
        print('Enter menu ID:');
        int? menuID = int.tryParse(stdin.readLineSync() ?? '');
        print('Product Name:');
        String? productName = stdin.readLineSync();
        print('Enter Quantity:');
        int? qty = int.tryParse(stdin.readLineSync() ?? '');
        print('Enter Price:');
        double? price = double.tryParse(stdin.readLineSync() ?? '');
        print('Type (food, drink, dessert):');
        String? typeInput = stdin.readLineSync();

        if (menuID != null && productName != null && qty != null && price != null && typeInput != null) {
          ProductType productType = ProductType.values.firstWhere((e) => e.toString().split('.').last == typeInput);
          var newItem = Menu(menuID, productName, qty, price, productType);
          Menu.addMenuItem(newItem);
          Menu.displayMenu();
        } else {
          print('Invalid input. Item not added.');
        }
        break;

      case '3':
        print('Enter menu ID to remove:');
        int? idToRemove = int.tryParse(stdin.readLineSync() ?? '');
        if (idToRemove != null) {
          Menu.removeMenuItem(idToRemove);
          Menu.displayMenu();
        } else {
          print('Invalid ID.');
        }
        break;

      case '4':
        print('Enter order ID:');
        int orderId = int.parse(stdin.readLineSync()!);
        var order = Order(orderId);

        Menu.displayMenu();
        print('Enter the menu ID to order (Enter 0 to finish):');
        while (true) {
          String? input = stdin.readLineSync();
          if (input == '0') break;
          int itemId = int.parse(input!);
          var item = Menu.menuItems.firstWhere((menuItem) => menuItem.menuID == itemId);
          order.addOrderItem(item);
        }
        customer1.placeOrder(order); // Link order to customer
        order.displayOrder();
        order.processPayment();
        break;

      case '5':
            print('Enter Table ID:');
            int tableId = int.parse(stdin.readLineSync()!);

            DateTime? reservationDate;
            while (reservationDate == null) {
              print('Today\'s date:');
              String? dateInput = stdin.readLineSync();

              try {
                if (dateInput == null || dateInput.isEmpty) {
                  // If the input is empty, use the current date
                  reservationDate = DateTime.now();
                  print('Using today\'s date: ${reservationDate.toIso8601String()}');
                } else {
                  // Parse the entered date
                  reservationDate = DateTime.parse(dateInput);
                }
              } catch (e) {
                print('Invalid date format. Please enter the date in YYYY-MM-DD format, or press Enter to use today\'s date.');
              }
            }

            var reservation = TableReservation(tableId, reservationDate);
            reservation.reserveTable();
            customer1.makeReservation(reservation);
           // Link reservation to customer
            reservation.displayReservation();
            break;
      case '6':
        customer1.displayCustomer(); // Display customer details, including orders and reservations
        break;

      case '0':
        continueProgram = false;
        print('Thank you for using the system. Goodbye!');
        break;

      default:
        print('Invalid choice. Please try again.');
    }
  } while (continueProgram);
}