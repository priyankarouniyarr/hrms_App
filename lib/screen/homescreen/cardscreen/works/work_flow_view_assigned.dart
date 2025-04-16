import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/providers/works_Summary_provider/ticket_workflow.dart';

class WorkFlowViewAssigned extends StatefulWidget {
  final Function(int) onDetailsAssignedViewed;
  final Function(int) onTicketAssignedClosedOrReopened;

  const WorkFlowViewAssigned(
      {super.key,
      required this.onDetailsAssignedViewed,
      required this.onTicketAssignedClosedOrReopened});

  @override
  State<WorkFlowViewAssigned> createState() => _WorkFlowViewAssignedState();
}

class _WorkFlowViewAssignedState extends State<WorkFlowViewAssigned> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TicketWorkFlowProvider>(context, listen: true);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: provider.myTicketAssignToMe.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text('No tickets found.'),
              ),
            )
          : ListView.builder(
              itemCount: provider.myTicketAssignToMe.length,
              itemBuilder: (context, index) {
                final ticket = provider.myTicketAssignToMe[index];
                return Card(
                  key: ValueKey(ticket.id),
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
                                ticket.title,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Card(
                              color: ticket.status == "Open"
                                  ? Colors.red
                                  : Colors
                                      .green, // Red for "open", green for "closed"
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  ticket.status,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "id",
                              style: TextStyle(fontSize: 14.0),
                            ),
                            Text(
                              "${ticket.id}",
                              style: TextStyle(fontSize: 14.0),
                            )
                          ],
                        ),
                        Html(
                          data: ticket.description,
                          style: {
                            "body": Style(
                              fontSize: FontSize(14.0),
                              color: Colors.black54,
                              fontWeight: FontWeight.w700,
                            ),
                          },
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Category",
                              style: TextStyle(fontSize: 14.0),
                            ),
                            Text(
                              ticket.ticketNo2.contains('-')
                                  ? ticket.ticketNo2
                                      .split('-')
                                      .last
                                      .replaceAll(RegExp(r'[0-9]'), '')
                                  : ticket.ticketNo2,
                              style: TextStyle(fontSize: 14.0),
                            )
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
                              ticket.severity,
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
                              ticket.priority,
                              style: TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Status",
                              style: TextStyle(fontSize: 14.0),
                            ),
                            Text(
                              ticket.status,
                              style: TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Issued By",
                              style: TextStyle(fontSize: 14.0),
                            ),
                            Text(
                              ticket.issueBy,
                              style: TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                        SizedBox(height: 25.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                widget.onDetailsAssignedViewed(ticket.id);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: primarySwatch,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.visibility,
                                        color: Colors.white, size: 16),
                                    SizedBox(width: 4),
                                    Text(
                                      'View',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 10),

                            // Close Button with icon
                            GestureDetector(
                              onTap: () async {
                                bool? confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Are you sure?'),
                                    content: Text(ticket.status == "Open"
                                        ? 'Do you want to close this ticket?'
                                        : 'Do you want to reopen this ticket?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: Text('Confirm'),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm == true) {
                                  widget.onTicketAssignedClosedOrReopened(
                                      ticket.id);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          ticket.status == "Open"
                                              ? 'Successfully closed the ticket'
                                              : 'Successfully reopened the ticket',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.green,
                                          )),
                                      backgroundColor: Colors.white,
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: ticket.status == "Open"
                                      ? Colors.red
                                      : const Color.fromARGB(255, 222, 85, 0),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      ticket.status == "Open"
                                          ? Icons.close
                                          : Icons.refresh,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      ticket.status == "Open"
                                          ? 'Close'
                                          : 'Reopen',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
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
