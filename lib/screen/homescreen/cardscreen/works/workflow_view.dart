import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/screen/leaves/dropdown_custom.dart';
import 'package:hrms_app/screen/leaves/customtextfieldform.dart';
import 'package:hrms_app/providers/works_Summary_provider/ticket_workflow.dart';
import 'package:hrms_app/screen/homescreen/cardscreen/works/details.screen.dart';
import 'package:hrms_app/models/works_models/myticket_and_assignbyme_ticket_model.dart';
import 'package:hrms_app/screen/homescreen/cardscreen/works/work_flow_view_assigned.dart';
import 'package:hrms_app/screen/homescreen/cardscreen/works/work_flow_view_myticket.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen%20categories/customprofile_appbar.dart';

class WorkflowView extends StatefulWidget {
  @override
  State<WorkflowView> createState() => _WorkflowViewState();
}

class _WorkflowViewState extends State<WorkflowView> {
  int _selectedIndex = 0;
  bool _isInitialized = false;
  String? _selectedStatus;
  String? _selectedServity;
  String? _selectedPriority;
  String? _selectedWorkflowType;
  final TextEditingController _primarystartcontroller = TextEditingController();
  final TextEditingController _primaryenddatecontroller =
      TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  Future<void> _initializeData() async {
    final DateTime now = DateTime.now();
    final DateTime fourMonthsAgo = DateTime(
      now.month > 4 ? now.year : now.year - 1,
      now.month > 4 ? now.month - 4 : now.month + 8,
      now.day,
    );

    final String fromdate =
        "${fourMonthsAgo.year}-${fourMonthsAgo.month.toString().padLeft(2, '0')}-${fourMonthsAgo.day.toString().padLeft(2, '0')}";
    final String todate =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    final requestTicket = MyticketPost(
      CategoryId: 0,
      status: "",
      priority: "",
      severity: "",
      assignTo: "",
      fromdate: fromdate,
      todate: todate,
      orderby: 'Oldest',
    );
    final provider =
        Provider.of<TicketWorkFlowProvider>(context, listen: false);
    await provider.fetchTickets(requestTicket);
    await provider.fetchAssigntoMeTickets(requestTicket);

    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TicketWorkFlowProvider>(context, listen: true);

    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: CustomAppBarProfile(title: "All WorkFlows"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                children: [
                  // First Dropdown (Status)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ' Status',
                          style: TextStyle(
                              color: primarySwatch,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        CustomDropdown(
                          value: _selectedStatus,
                          items: provider.status,
                          hintText: "",
                          onChanged: (value) {
                            setState(() {
                              _selectedStatus = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 10), // Spacing between dropdowns

                  // Second Dropdown (Severity)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Servity',
                          style: TextStyle(
                              color: primarySwatch,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        CustomDropdown(
                          value: _selectedServity,
                          items: provider.servity,
                          hintText: "",
                          onChanged: (value) {
                            setState(() {
                              _selectedServity = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Priority',
                          style: TextStyle(
                              color: primarySwatch,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        CustomDropdown(
                          value: _selectedPriority,
                          items: provider.priority,
                          hintText: "",
                          onChanged: (value) {
                            setState(() {
                              _selectedPriority = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Type',
                          style: TextStyle(
                              color: primarySwatch,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        CustomDropdown(
                          value: _selectedWorkflowType,
                          items: provider.workflowType,
                          hintText: "",
                          onChanged: (value) {
                            setState(() {
                              _selectedWorkflowType = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Start Date",
                            style: TextStyle(
                                fontSize: 16,
                                color: primarySwatch,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        CustomTextFormField(
                          controller: _primarystartcontroller,
                          hintText: "Start date",
                          readOnly: true,
                          validator: (value) => _startDate == null
                              ? 'Start date is required'
                              : null,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate:
                                  DateTime.now().add(Duration(days: 1)),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                _startDate = pickedDate;
                                _primarystartcontroller.text =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                // Clear end date if new start date is after current end date
                                if (_endDate != null &&
                                    _endDate!.isBefore(pickedDate)) {
                                  _endDate = null;
                                  _primaryenddatecontroller.clear();
                                }
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("End Date",
                            style: TextStyle(
                                fontSize: 16,
                                color: primarySwatch,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        CustomTextFormField(
                          controller: _primaryenddatecontroller,
                          hintText: "End date",
                          readOnly: true,
                          validator: (value) => _endDate == null
                              ? 'End date is required'
                              : (_startDate != null &&
                                      _endDate!.isBefore(_startDate!))
                                  ? 'End date must be after start date'
                                  : null,
                          onTap: () async {
                            //   _formKey.currentState?.validate();
                            if (_startDate == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Please select start date first",
                                    style: TextStyle(color: accentColor),
                                  ),
                                  backgroundColor: cardBackgroundColor,
                                ),
                              );
                              return;
                            }
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: _startDate!.add(Duration(days: 1)),
                              firstDate: _startDate!,
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                _endDate = pickedDate;
                                _primaryenddatecontroller.text =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),
              Divider(color: primarySwatch),
              SizedBox(height: 15),
              Container(
                height: 60,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: lightColor),
                ),
                child: ToggleButtons(
                  isSelected: [_selectedIndex == 0, _selectedIndex == 1],
                  onPressed: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  color: primaryTextColor,
                  selectedColor: backgroundColor,
                  fillColor: primarySwatch[900],
                  borderRadius: BorderRadius.circular(10),
                  borderColor: lightColor,
                  selectedBorderColor: primarySwatch[900],
                  textStyle: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: Text('My Ticket', style: TextStyle(fontSize: 18)),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text('Assigned By Me',
                          style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Show loading/error/content based on state
              if (!_isInitialized || provider.isLoading)
                Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (provider.errormessage != null)
                Expanded(
                  child: Center(
                    child: Text(
                      provider.errormessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                )
              else
                Expanded(
                  child: _selectedIndex == 0
                      ? WorkFlowViewMyTicket(
                          onDetailsViewed: (ticketID) async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TicketDetailScreen(ticketId: ticketID),
                              ),
                            );
                            await _initializeData();
                          },
                        )
                      : WorkFlowViewAssigned(
                          // onDetailsAssignedViewed: (ticketID) async {
                          //   await Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) =>
                          //           TicketDetailScreen(ticketId: ticketID),
                          //     ),
                          //   );
                          //   await _initializeData();
                          // },
                          ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
