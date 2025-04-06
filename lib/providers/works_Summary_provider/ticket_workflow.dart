import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:hrms_app/storage/securestorage.dart';
import 'package:hrms_app/models/works_models/ticketdetails_with_id.dart';
import 'package:hrms_app/models/works_models/myticket_and_assignbyme_ticket_model.dart';

class TicketWorkFlowProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errormessage;
  List<TicketMeAndAssignToMe> _myTicket = [];
  List<TicketMeAndAssignToMe> _myTicketAssignToMe = [];
  final SecureStorageService _secureStorageService = SecureStorageService();
  String? _branchId;
  String? _token;
  String? _fiscalYear;

  List<TicketMeAndAssignToMe> get myTicket => _myTicket;
  List<TicketMeAndAssignToMe> get myTicketAssignToMe => _myTicketAssignToMe;
  bool get isLoading => _isLoading;
  String? get errormessage => _errormessage;
  List<TicketDetailsWithId> _myticketdetailsbyId = [];
  List<TicketDetailsWithId> get myticketdetails => _myticketdetailsbyId;
  // Add this variable to store the ticket ID from POST response

  List<String> _status = ["Open", "Closed"];
  List<String> get status => _status;
  List<String> _servity = ["Low", "Medium", "High"];
  List<String> get servity => _servity;
  List<String> _priority = ["Low", "Medium", "High"];
  List<String> get priority => _priority;
  List<String> _workflowType = ["Oldest", "Newest"];
  List<String> get workflowType => _workflowType;
  Future<void> fetchTickets(MyticketPost requestticket) async {
    _isLoading = true;
    notifyListeners();

    try {
      _branchId = await _secureStorageService.readData('workingBranchId');
      _token = await _secureStorageService.readData('auth_token');
      _fiscalYear =
          await _secureStorageService.readData('selected_fiscal_year');
      // print(_branchId);
      if (_token == null || _branchId == null || _fiscalYear == null) {
        _errormessage = 'Missing required credentials';
        _isLoading = false;
        notifyListeners();
        return;
      }

      const String url = 'http://45.117.153.90:5004/api/Ticket/MyTickets';
      final requestBody = jsonEncode(requestticket.toJson());
      //  print('Sending request with body: $requestBody');

      final response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_token',
            'workingBranchId': _branchId!,
            'workingFinancialId': _fiscalYear!,
          },
          body: jsonEncode(requestticket.toJson()));
      // print('Status Code: ${response.statusCode}');
      // print('Response Body: ${response.body}');
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        // print("sucessfully");
        _myTicket =
            responseData.map((e) => TicketMeAndAssignToMe.fromJson(e)).toList();

        ;
        _errormessage = null;
        notifyListeners();
      } else {
        _errormessage = 'Failed to load tickets: ${response.statusCode}';
      }
    } catch (e) {
      _errormessage = 'Error fetching tickets: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

//assign me portion
  Future<void> fetchAssigntoMeTickets(MyticketPost requestticket) async {
    _isLoading = true;
    notifyListeners();

    try {
      _branchId = await _secureStorageService.readData('workingBranchId');
      _token = await _secureStorageService.readData('auth_token');
      _fiscalYear =
          await _secureStorageService.readData('selected_fiscal_year');

      if (_token == null || _branchId == null || _fiscalYear == null) {
        _errormessage = 'Missing required credentials';
        _isLoading = false;
        notifyListeners();
        return;
      }

      const String url =
          'http://45.117.153.90:5004/api/Ticket/TicketsAssignedToMe';

      final response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_token',
            'workingBranchId': _branchId!,
            'workingFinancialId': _fiscalYear!,
          },
          body: jsonEncode(requestticket.toJson()));
      // print('Status Code: ${response.statusCode}');
      // print('Response Body: ${response.body}');
      if (response.statusCode == 200) {
        final List<dynamic> responseAssignToMe = json.decode(response.body);

        _myTicketAssignToMe = responseAssignToMe
            .map((e) => TicketMeAndAssignToMe.fromJson(e))
            .toList();

        ;
        _errormessage = null;
        notifyListeners();
      } else {
        _errormessage = 'Failed to load tickets: ${response.statusCode}';
      }
    } catch (e) {
      _errormessage = 'Error fetching tickets: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

//getdetails by id
  Future<void> fetchMyTicketDetaisById({required int ticket}) async {
    _isLoading = true;
    _errormessage = '';
    notifyListeners();

    try {
      String? token = await _secureStorageService.readData('auth_token');
      String? branchId =
          await _secureStorageService.readData('workingBranchId');
      String? fiscalYear =
          await _secureStorageService.readData('selected_fiscal_year');
      print(branchId);
      if (token == null || branchId == null || fiscalYear == null) {
        throw Exception("Missing authentication data.");
      }
      print("hello");

      final url = Uri.parse(
          'http://45.117.153.90:5004/api/Ticket/GetTicketDetailById/$ticket');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'workingBranchId': branchId,
          'workingFinancialId': fiscalYear,
        },
      );
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      print("hello");
      if (response.statusCode == 200) {
        Map<String, dynamic> responseDetails = json.decode(response.body);

        _myticketdetailsbyId = [
          TicketDetailsWithId.fromJson(responseDetails),
        ];
        print(_myticketdetailsbyId);
        notifyListeners();

        _errormessage = '';
        notifyListeners();
      } else {
        _errormessage = 'Failed to load ticket summary';
      }
    } catch (e) {
      _errormessage = 'An error occurred: ${e.toString()}';
      print(_errormessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
