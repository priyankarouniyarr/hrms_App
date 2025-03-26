import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:hrms_app/storage/securestorage.dart';
import 'package:hrms_app/models/works_models/tickets_filter_models.dart';
import 'package:hrms_app/models/works_models/ticket_workflow_models.dart';

class TicketWorkFlowProvider with ChangeNotifier {
  List<Ticket> _tickets = [];
  List<Ticket> _filteredTickets = [];
  bool _isLoading = false;
  String? _errormessage;
  TicketFilter _currentFilter = TicketFilter();
  final SecureStorageService _secureStorageService = SecureStorageService();
  String? _branchId;
  String? _token;
  String? _fiscalYear;
  List<Ticket> get tickets => _filteredTickets;
  bool get isLoading => _isLoading;
  String? get errormessage => _errormessage;
  TicketFilter get currentFilter => _currentFilter;

  Future<void> fetchTickets({TicketFilter? filter}) async {
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

      const String url = 'http://45.117.153.90:5004/api/Ticket/MyTickets';

      final response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_token',
            'workingBranchId': _branchId!,
            'workingFinancialId': _fiscalYear!,
          },
          body: jsonEncode([filter!.toJson()]));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        _tickets = responseData.map((json) => Ticket.fromJson(json)).toList();
        _filteredTickets = _tickets;
        _errormessage = null;
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

  void applyFilter(TicketFilter filter) {
    _currentFilter = filter;
    _filteredTickets = _tickets.where((ticket) {
      if (filter.categoryId > 0 &&
          ticket.ticketCategoryId != filter.categoryId) {
        return false;
      }

      // Status filter
      if (filter.status.isNotEmpty && ticket.status != filter.status) {
        return false;
      }

      // Priority filter
      if (filter.priority.isNotEmpty && ticket.priority != filter.priority) {
        return false;
      }

      // Severity filter
      if (filter.severity.isNotEmpty && ticket.severity != filter.severity) {
        return false;
      }

      // AssignedTo filter (case insensitive)
      if (filter.assignedTo.isNotEmpty &&
          !ticket.assignedTo
              .toLowerCase()
              .contains(filter.assignedTo.toLowerCase())) {
        return false;
      }

      return true;
    }).toList();

    notifyListeners();
  }

  void clearFilters() {
    _currentFilter = TicketFilter();
    _filteredTickets = _tickets;
    notifyListeners();
  }
}
