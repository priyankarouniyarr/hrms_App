import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/providers/works_Summary_provider/ticket_workflow.dart';

class TicketDetailScreen extends StatefulWidget {
  const TicketDetailScreen({super.key});

  @override
  State<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TicketWorkFlowProvider>(context, listen: true);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: provider.myticketdetails.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text('No tickets found.'),
              ),
            )
          : ListView.builder(
              itemCount: provider.myTicketAssignToMe.length,
              itemBuilder: (context, index) {
                final ticket = provider.myticketdetails[index];
                return Card(
                  color: Colors.white,
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: primarySwatch, width: 1),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      .replaceAll(RegExp(r'[0-9]'), '')
                                  : ticket.ticket.ticketNo2,
                              style: TextStyle(fontSize: 14.0),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 8.0,
                        ), // Ticket ID
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              " Attachment Document ",
                              style: TextStyle(fontSize: 14.0),
                            ),
                            Text(
                              ticket.ticket.assignedOn.toString(),
                              style: TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
