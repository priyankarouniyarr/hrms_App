import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/providers/works_Summary_provider/ticket_workflow.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen%20categories/customprofile_appbar.dart';

class TicketDetailScreen extends StatefulWidget {
  final int ticketId;
  TicketDetailScreen({required this.ticketId});
  @override
  State<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  @override
  void initState() {
    super.initState();
    print(widget.ticketId);
    Future.microtask(() {
      Provider.of<TicketWorkFlowProvider>(context, listen: false)
          .fetchMyTicketDetaisById(ticket: widget.ticketId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TicketWorkFlowProvider>(context, listen: true);

    return Scaffold(
        backgroundColor: cardBackgroundColor,
        appBar: CustomAppBarProfile(title: "Ticket Information"),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: provider.myticketdetails.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text('No tickets found.'),
                    ),
                  )
                : ListView.builder(
                    itemCount: provider.myticketdetails.length,
                    itemBuilder: (context, index) {
                      final ticket = provider.myticketdetails[index];
                      return Card(
                          color: Colors.white,
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                                color: primarySwatch, width: 1),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          ticket.ticket.title,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      Card(
                                        color: ticket.ticket.status == "Open"
                                            ? Colors.red
                                            : Colors
                                                .green, // Red for "open", green for "closed"
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            ticket.ticket.status,
                                            style: const TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors
                                                  .white, // White text for better contrast
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),

                                  Html(
                                    data: ticket.ticket.description,
                                    style: {
                                      "body": Style(
                                        fontSize: FontSize(14.0),
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    },
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ), // Ticket ID
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Ticket No ",
                                        style: TextStyle(fontSize: 14.0),
                                      ),
                                      Text(
                                        ticket.ticket.ticketNo,
                                        style: TextStyle(fontSize: 14.0),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ), // Ticket ID
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Registration",
                                        style: TextStyle(fontSize: 14.0),
                                      ),
                                      Text(
                                        ticket.ticket.ticketNo2,
                                        style: TextStyle(fontSize: 14.0),
                                      )
                                    ],
                                  ),

                                  SizedBox(
                                    height: 8.0,
                                  ), // Ticket ID
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Category",
                                        style: TextStyle(fontSize: 14.0),
                                      ),
                                      Text(
                                        ticket.ticket.ticketNo2.contains('-')
                                            ? ticket.ticket.ticketNo2
                                                .split('-')
                                                .last
                                                .replaceAll(
                                                    RegExp(r'[0-9]'), '')
                                            : ticket.ticket.ticketNo2,
                                        style: TextStyle(fontSize: 14.0),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ), // Ticket ID
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Created On",
                                        style: TextStyle(fontSize: 14.0),
                                      ),
                                      Text(
                                        ticket.ticket.ticketDate.toString(),
                                        style: TextStyle(fontSize: 14.0),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 8.0),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Created By",
                                        style: TextStyle(fontSize: 14.0),
                                      ),
                                      Text(
                                        ticket.ticket.issueBy,
                                        style: TextStyle(fontSize: 14.0),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 8.0),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Serverity",
                                        style: TextStyle(fontSize: 14.0),
                                      ),
                                      Text(
                                        ticket.ticket.severity,
                                        style: TextStyle(fontSize: 14.0),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.0),
                                  // Priority
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Priority",
                                        style: TextStyle(fontSize: 14.0),
                                      ),
                                      Text(
                                        ticket.ticket.priority,
                                        style: TextStyle(fontSize: 14.0),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.0),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Assigned To",
                                        style: TextStyle(fontSize: 14.0),
                                      ),
                                      Text(
                                        ticket.ticket.assignedTo,
                                        style: TextStyle(fontSize: 14.0),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        " Assigned On ",
                                        style: TextStyle(fontSize: 14.0),
                                      ),
                                      Text(
                                        ticket.ticket.assignedOn.toString(),
                                        style: TextStyle(fontSize: 14.0),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.0),
                                  SizedBox(height: 8.0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        " LastModified On ",
                                        style: TextStyle(fontSize: 14.0),
                                      ),
                                      Text(
                                        ticket.ticket.updateTime.toString(),
                                        style: TextStyle(fontSize: 14.0),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        //image portion

                                        " Attachment Document ",
                                        style: TextStyle(fontSize: 14.0),
                                      ),
                                      Text(
                                        ticket.ticket.assignedOn.toString(),
                                        style: TextStyle(fontSize: 14.0),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15.0),
                                  DottedLine(
                                    dashLength: 2,
                                    dashColor: primarySwatch,
                                  ),
                                  SizedBox(height: 15.0),
                                  Text(
                                    "Ticket Timeline",
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(height: 8.0),
                                  // ListView(
                                  //   padding: const EdgeInsets.all(16.0),
                                  //   children: const [
                                  //     TimelineItem(
                                  //       date: '21st Feb, 2025 10:35',
                                  //       action: 'closed the ticket',
                                  //       user: 'priyanka',
                                  //       isFirst: true,
                                  //     ),
                                  //   ],
                                  // ),
                                ]),
                          ));
                    },
                  ),
          ),
        ));
  }
}

class TimelineItem extends StatelessWidget {
  final String date;
  final String action;
  final String user;
  final bool isFirst;
  final bool isLast;

  const TimelineItem({
    super.key,
    required this.date,
    required this.action,
    required this.user,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline line and dot
          Column(
            children: [
              // Top line (only if not first item)
              if (!isFirst)
                Container(
                  width: 2,
                  height: 20,
                  color: Colors.grey[400],
                ),
              // Dot
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: _getActionColor(action),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey[400]!,
                    width: 2,
                  ),
                ),
              ),
              // Bottom line (only if not last item)
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: Colors.grey[400],
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    date,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: user,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: ' $action'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getActionColor(String action) {
    return action.contains('closed') ? Colors.red : Colors.green;
  }
}
