import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/screen/leaves/dropdown_custom.dart';
import 'package:hrms_app/screen/leaves/customtextfieldform.dart';
import 'package:hrms_app/providers/works_Summary_provider/ticket_workflow.dart';
import 'package:hrms_app/models/works_models/myticket_and_assignbyme_ticket_model.dart';
import 'package:hrms_app/screen/homescreen/cardscreen/works/work_flow_view_assigned.dart';
import 'package:hrms_app/screen/homescreen/cardscreen/works/work_flow_view_myticket.dart';
import 'package:hrms_app/screen/homescreen/cardscreen/works/details_screen/details.screen.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen%20categories/customprofile_appbar.dart';

class WorkflowView extends StatefulWidget {
  @override
  State<WorkflowView> createState() => _WorkflowViewState();
}

class _WorkflowViewState extends State<WorkflowView> {
  int _selectedIndex = 0;
  bool _isInitialized = false;
  bool _isLoading = false;
  String? _selectedStatus = "Open";
  String? _selectedServity;
  String? _selectedPriority;
  String? _selectedWorkflowType = "Oldest";

  final TextEditingController _primarystartcontroller = TextEditingController();
  final TextEditingController _primaryenddatecontroller =
      TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    final DateTime now = DateTime.now();
    final DateTime twoMonthsAgo = DateTime(now.year, now.month - 2, now.day);
    _startDate = twoMonthsAgo;
    _endDate = now;
    _primarystartcontroller.text =
        DateFormat('yyyy-MM-dd').format(twoMonthsAgo);
    _primaryenddatecontroller.text = DateFormat('yyyy-MM-dd').format(now);
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeData());
  }

  @override
  void dispose() {
    _primarystartcontroller.dispose();
    _primaryenddatecontroller.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    setState(() => _isLoading = true);

    final requestTicket = MyticketPost(
      CategoryId: 0,
      status: _selectedStatus ?? "",
      priority: _selectedPriority ?? "",
      severity: _selectedServity ?? "",
      assignTo: " ",
      fromdate: _primarystartcontroller.text,
      todate: _primaryenddatecontroller.text,
      orderby: _selectedWorkflowType ?? "",
    );
    try {
      if (_selectedIndex == 0) {
        await Provider.of<TicketWorkFlowProvider>(context, listen: false)
            .fetchTickets(requestTicket);
      } else {
        await Provider.of<TicketWorkFlowProvider>(context, listen: false)
            .fetchAssigntoMeTickets(requestTicket);
      }
    } catch (e) {
      print(e);

      // Handle error if needed
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isInitialized = true;
        });
      }
    }
  }

  void _applyFilters() {
    setState(() => _isInitialized = false);
    _initializeData();
  }

  void _clearFilters() {
    final now = DateTime.now();
    final twoMonthsAgo = DateTime(now.year, now.month - 2, now.day);
    setState(() {
      _selectedStatus = "Open";
      _selectedServity = "";
      _selectedPriority = "";
      _selectedWorkflowType = "Oldest";
      _startDate = twoMonthsAgo;
      _endDate = now;
      _primarystartcontroller.text =
          DateFormat('yyyy-MM-dd').format(twoMonthsAgo);
      _primaryenddatecontroller.text = DateFormat('yyyy-MM-dd').format(now);
    });
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TicketWorkFlowProvider>(context);

    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: CustomAppBarProfile(title: "All WorkFlows"),
      body: !_isInitialized
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      /// Filter Form
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                _buildDropdown(
                                    "Status",
                                    _selectedStatus,
                                    provider.status,
                                    (value) => setState(
                                        () => _selectedStatus = value)),
                                SizedBox(width: 10),
                                _buildDropdown(
                                    "Servity",
                                    _selectedServity,
                                    provider.servity,
                                    (value) => setState(
                                        () => _selectedServity = value)),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                _buildDropdown(
                                    "Priority",
                                    _selectedPriority,
                                    provider.priority,
                                    (value) => setState(
                                        () => _selectedPriority = value)),
                                SizedBox(width: 10),
                                _buildDropdown(
                                    "Type",
                                    _selectedWorkflowType,
                                    provider.workflowType,
                                    (value) => setState(
                                        () => _selectedWorkflowType = value)),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                _buildDateField(
                                    "Start Date",
                                    _primarystartcontroller,
                                    _startDate, (picked) {
                                  setState(() {
                                    _startDate = picked;
                                    _primarystartcontroller.text =
                                        DateFormat('yyyy-MM-dd').format(picked);
                                    if (_endDate != null &&
                                        _endDate!.isBefore(picked)) {
                                      _endDate = null;
                                      _primaryenddatecontroller.clear();
                                    }
                                  });
                                }),
                                SizedBox(width: 10),
                                _buildDateField(
                                    "End Date",
                                    _primaryenddatecontroller,
                                    _endDate, (picked) {
                                  setState(() {
                                    _endDate = picked;
                                    _primaryenddatecontroller.text =
                                        DateFormat('yyyy-MM-dd').format(picked);
                                  });
                                }, startDate: _startDate),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton.icon(
                                  onPressed: _clearFilters,
                                  icon:
                                      Icon(Icons.refresh, color: primarySwatch),
                                  label: Text('Clear Filters',
                                      style: TextStyle(color: primarySwatch)),
                                ),
                                ElevatedButton.icon(
                                  onPressed: _applyFilters,
                                  icon: Icon(Icons.filter_alt),
                                  label: Text("Apply"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: cardBackgroundColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(color: primarySwatch),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 10),

                      /// Toggle My Ticket / Assigned By Me
                      Container(
                        height: 55,
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: lightColor),
                        ),
                        child: ToggleButtons(
                          isSelected: [
                            _selectedIndex == 0,
                            _selectedIndex == 1
                          ],
                          onPressed: (index) {
                            setState(() => _selectedIndex = index);
                            _applyFilters();
                          },
                          color: primaryTextColor,
                          selectedColor: Colors.white,
                          fillColor: primarySwatch[700],
                          borderRadius: BorderRadius.circular(10),
                          borderColor: lightColor,
                          selectedBorderColor: primarySwatch[900],
                          textStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          children: const [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              child: Row(
                                children: [
                                  Icon(Icons.assignment_ind),
                                  SizedBox(width: 6),
                                  Text('My Ticket'),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: [
                                  Icon(Icons.assignment_turned_in),
                                  SizedBox(width: 6),
                                  Text('Assigned to Me'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 16),

                      /// Data Section
                      if (_isLoading)
                        SizedBox(
                            height: 300,
                            child: Center(child: CircularProgressIndicator()))
                      else if (provider.errormessage != null)
                        SizedBox(
                          height: 300,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                provider.errormessage!,
                                style: TextStyle(color: accentColor),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          ),
                        )
                      else
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: _selectedIndex == 0
                              ? WorkFlowViewMyTicket(
                                  onTicketClosedOrReopened: (ticketID) async {
                                    try {
                                      final ticket = provider.myTicket
                                          .firstWhere((t) => t.id == ticketID);

                                      ticket.status == "Open"
                                          ? await provider.closedTicketById(
                                              ticketId: ticketID)
                                          : await provider.reopenTicketById(
                                              ticketId: ticketID);

                                      await _initializeData();
                                    } catch (e) {
                                      // print(
                                      //     "Error: Ticket with ID $ticketID not found or action failed: $e");
                                    }
                                  },
                                  onDetailsViewed: (ticketID) async {
                                    bool? resp = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TicketDetailScreen(
                                                ticketId: ticketID),
                                      ),
                                    );

                                    if (resp == true) {
                                      if (_selectedStatus == "Open") {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Successfully closed the ticket",
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 16,
                                              ),
                                            ),
                                            backgroundColor:
                                                cardBackgroundColor,
                                            duration: Duration(seconds: 3),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Successfully reopened the card",
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 16,
                                              ),
                                            ),
                                            backgroundColor:
                                                cardBackgroundColor,
                                            duration: Duration(seconds: 3),
                                          ),
                                        );
                                      }
                                    }

                                    // Call _initializeData after the condition
                                    await _initializeData();
                                  },
                                )
                              : WorkFlowViewAssigned(
                                  onTicketAssignedClosedOrReopened:
                                      (ticketID) async {
                                    try {
                                      final ticket = provider.myTicketAssignToMe
                                          .firstWhere((t) => t.id == ticketID);

                                      ticket.status == "Open"
                                          ? await provider.closedTicketById(
                                              ticketId: ticketID)
                                          : await provider.reopenTicketById(
                                              ticketId: ticketID);

                                      await _initializeData();
                                    } catch (e) {
                                      print(
                                          "Error: Ticket with ID $ticketID not found or action failed: $e");
                                    }
                                  },
                                  onDetailsAssignedViewed: (ticketID) async {
                                    bool? resp = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TicketDetailScreen(
                                                ticketId: ticketID),
                                      ),
                                    );

                                    if (resp == true) {
                                      print(
                                          "Response from TicketDetailScreen: $resp");
                                      print(
                                          "Provider status: ${provider.status}");

                                      if (provider.status == "Open") {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Successfully closed the ticket",
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 16,
                                              ),
                                            ),
                                            backgroundColor:
                                                cardBackgroundColor,
                                            duration: Duration(seconds: 3),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Successfully reopened the card",
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 16,
                                              ),
                                            ),
                                            backgroundColor:
                                                cardBackgroundColor,
                                            duration: Duration(seconds: 3),
                                          ),
                                        );
                                      }
                                    }

                                    // Call _initializeData after the condition
                                    await _initializeData();
                                  },
                                ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Expanded _buildDropdown(String title, String? value, List<String> items,
      ValueChanged<String?> onChanged) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  color: primarySwatch,
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
          SizedBox(height: 5),
          CustomDropdownClearFilters(
            value: value,
            items: items,
            hintText: "",
            onChanged: (val) {
              onChanged(val);
              _applyFilters();
            },
          ),
        ],
      ),
    );
  }

  Expanded _buildDateField(String label, TextEditingController controller,
      DateTime? selectedDate, ValueChanged<DateTime> onPicked,
      {DateTime? startDate}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  color: primarySwatch,
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
          SizedBox(height: 5),
          CustomTextFormField(
            controller: controller,
            readOnly: true,
            hintText: label,
            suffixIcon:
                Icon(Icons.calendar_today, size: 12, color: primarySwatch),
            validator: (value) {
              if (selectedDate == null) return '$label is required';
              if (label == "End Date" &&
                  startDate != null &&
                  selectedDate.isBefore(startDate)) {
                return 'End date must be after start date';
              }
              return null;
            },
            onTap: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: selectedDate ?? DateTime.now(),
                firstDate:
                    startDate ?? DateTime.now().subtract(Duration(days: 365)),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                onPicked(picked);
                _applyFilters();
              }
            },
          ),
        ],
      ),
    );
  }
}
