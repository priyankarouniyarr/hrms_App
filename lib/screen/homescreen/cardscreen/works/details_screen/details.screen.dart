import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/widget/dropdown_custom.dart';
import 'package:hrms_app/models/works_models/reopen%20_ticket_models.dart';
import 'package:hrms_app/providers/create_tickets/ne_tickets_providers.dart';
import 'package:hrms_app/providers/works_Summary_provider/ticket_workflow.dart';
import 'package:hrms_app/screen/homescreen/cardscreen/works/details_screen/comment_dailog.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen%20categories/customprofile_appbar.dart';

class TicketDetailScreen extends StatefulWidget {
  final int ticketId;

  TicketDetailScreen({
    required this.ticketId,
  });

  @override
  State<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  String? _selectedassigntoType;
  String? _selectedServity;
  String? _selectedPriority;
  late TicketWorkFlowProvider _ticketProvider;

  @override
  void initState() {
    super.initState();

    _ticketProvider =
        Provider.of<TicketWorkFlowProvider>(context, listen: false);

    Future.microtask(() async {
      await _ticketProvider.fetchMyTicketDetaisById(ticket: widget.ticketId);
      await Provider.of<NewTicketProvider>(context, listen: false)
          .fetchTicketCategories();

      if (_ticketProvider.myticketdetails.isNotEmpty) {
        final ticket = _ticketProvider.myticketdetails.first.ticket;
        setState(() {
          _selectedServity = ticket.severity;
          _selectedPriority = ticket.priority;
          _selectedassigntoType = ticket.assignToEmployeeId.toString();
        });
      }
    });
  }

  @override
  void dispose() {
    ;
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final priorityTicket = PriorityTicket(
      ticketId: widget.ticketId,
      priorityStatus: _selectedPriority!,
    );
    final assignToTicket = AssignToTicket(
      ticketId: widget.ticketId,
      userId: int.parse(_selectedassigntoType!),
    );
    final severityTicket = ServityTicket(
      ticketId: widget.ticketId,
      servityStatus: _selectedServity!,
    );

    await _ticketProvider.editServityTicketById(severityTicket);
    await _ticketProvider.editPriorityTicketById(priorityTicket);
    await _ticketProvider.editAssignToTicketById(assignToTicket);
    print(severityTicket.servityStatus);
    print(priorityTicket.priorityStatus);
    print(assignToTicket.userId);
    print(assignToTicket.ticketId);
    Navigator.pop(context);
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
          child: provider.isLoading
              ? Center(child: CircularProgressIndicator())
              : provider.myticketdetails.isEmpty
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
                        final formattedTime = ticket.ticket.updateTime != null
                            ? DateFormat('dd MMM yyyy ,HH:mm')
                                .format(ticket.ticket.updateTime!)
                            : 'null';

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
                                          : Colors.green,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          ticket.ticket.status,
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
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
                                SizedBox(height: 8.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Ticket No",
                                        style: TextStyle(fontSize: 14.0)),
                                    Text(ticket.ticket.ticketNo,
                                        style: TextStyle(fontSize: 14.0)),
                                  ],
                                ),
                                SizedBox(height: 8.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Registration",
                                        style: TextStyle(fontSize: 14.0)),
                                    Text(ticket.ticket.ticketNo2,
                                        style: TextStyle(fontSize: 14.0)),
                                  ],
                                ),
                                SizedBox(height: 8.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Category",
                                        style: TextStyle(fontSize: 14.0)),
                                    Text(
                                      ticket.ticket.ticketNo2.contains('-')
                                          ? ticket.ticket.ticketNo2
                                              .split('-')
                                              .last
                                              .replaceAll(RegExp(r'[0-9]'), '')
                                          : ticket.ticket.ticketNo2,
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Created On",
                                        style: TextStyle(fontSize: 14.0)),
                                    Text(
                                      DateFormat('dd MMM, yyyy').format(
                                          ticket.ticket.ticketDate.toLocal()),
                                      style: const TextStyle(fontSize: 14.0),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Created By",
                                        style: TextStyle(fontSize: 14.0)),
                                    Text(ticket.ticket.issueBy,
                                        style: TextStyle(fontSize: 14.0)),
                                  ],
                                ),
                                SizedBox(height: 8.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Serverity",
                                        style: TextStyle(fontSize: 14.0)),
                                    Text(ticket.ticket.severity,
                                        style: TextStyle(fontSize: 14.0)),
                                  ],
                                ),
                                SizedBox(height: 8.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Priority",
                                        style: TextStyle(fontSize: 14.0)),
                                    Text(ticket.ticket.priority,
                                        style: TextStyle(fontSize: 14.0)),
                                  ],
                                ),
                                SizedBox(height: 8.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Assigned To",
                                        style: TextStyle(fontSize: 14.0)),
                                    Text(ticket.ticket.assignedTo,
                                        style: TextStyle(fontSize: 14.0)),
                                  ],
                                ),
                                SizedBox(height: 8.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Assigned On",
                                        style: TextStyle(fontSize: 14.0)),
                                    Text(
                                      DateFormat('dd MMM, yyyy').format(
                                          ticket.ticket.assignedOn.toLocal()),
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("LastModified On",
                                        style: TextStyle(fontSize: 14.0)),
                                    Text(formattedTime,
                                        style: TextStyle(fontSize: 14.0)),
                                  ],
                                ),
                                SizedBox(height: 8.0),
                                ticket.ticket.attachedDocuments.isEmpty
                                    ? SizedBox.shrink()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Attachment Document",
                                              style: TextStyle(fontSize: 14.0)),
                                          InkWell(
                                            onTap: () {
                                              _showImageDialog(
                                                  context,
                                                  ticket.ticket
                                                      .attachedDocuments);
                                            },
                                            child: Icon(
                                                Icons.attach_file_rounded,
                                                color: primarySwatch),
                                          ),
                                        ],
                                      ),
                                SizedBox(height: 15.0),
                                DottedLine(
                                    dashLength: 2, dashColor: primarySwatch),
                                SizedBox(height: 15.0),
                                Text(
                                  "Ticket Timeline",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 8.0),
                                ticket.ticketActivity.isEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Text('No activities yet',
                                            style:
                                                TextStyle(color: Colors.grey)),
                                      )
                                    : Column(
                                        children: ticket.ticketActivity
                                            .map((activity) {
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(top: 0.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 15,
                                                      backgroundColor:
                                                          activity.comment !=
                                                                  null
                                                              ? primarySwatch
                                                              : Colors.amber,
                                                      child: activity.comment !=
                                                              null
                                                          ? Icon(Icons.email,
                                                              size: 18,
                                                              color:
                                                                  Colors.white)
                                                          : Icon(Icons.person,
                                                              size: 18,
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            activity.comment !=
                                                                    null
                                                                ? '${DateFormat('dd MMM, yyyy HH:mm').format(activity.commentDate)}'
                                                                : '${DateFormat('dd MMM, yyyy HH:mm').format(activity.replyOn)}',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black54),
                                                          ),
                                                          activity.comment !=
                                                                  null
                                                              ? Row(
                                                                  children: [
                                                                    Text.rich(
                                                                      TextSpan(
                                                                        children: [
                                                                          TextSpan(
                                                                            text:
                                                                                '${activity.replyBy} ',
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 14,
                                                                              color: primarySwatch,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                          TextSpan(
                                                                            text:
                                                                                '${activity.comment}',
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 14,
                                                                              color: Colors.black87,
                                                                              fontWeight: FontWeight.w500,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        width:
                                                                            15),
                                                                    activity.attachedDocuments
                                                                            .isEmpty
                                                                        ? SizedBox
                                                                            .shrink()
                                                                        : InkWell(
                                                                            onTap:
                                                                                () {
                                                                              _showImageDialog(context, activity.attachedDocuments);
                                                                            },
                                                                            child:
                                                                                Icon(
                                                                              Icons.attach_file_rounded,
                                                                              size: 18,
                                                                              color: primarySwatch,
                                                                            ),
                                                                          ),
                                                                  ],
                                                                )
                                                              : Row(
                                                                  children: [
                                                                    Text.rich(
                                                                      TextSpan(
                                                                        children: [
                                                                          TextSpan(
                                                                            text:
                                                                                '${activity.replyBy} ',
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 14,
                                                                              color: primarySwatch,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                          TextSpan(
                                                                            text:
                                                                                '${activity.ticketAction}',
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 14,
                                                                              color: Colors.black87,
                                                                              fontWeight: FontWeight.w500,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        width:
                                                                            5),
                                                                    activity.attachedDocuments
                                                                            .isEmpty
                                                                        ? SizedBox
                                                                            .shrink()
                                                                        : InkWell(
                                                                            onTap:
                                                                                () {
                                                                              _showImageDialog(context, activity.attachedDocuments);
                                                                            },
                                                                            child:
                                                                                Icon(
                                                                              Icons.attach_file_rounded,
                                                                              size: 18,
                                                                              color: primarySwatch,
                                                                            ),
                                                                          ),
                                                                  ],
                                                                ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                if (activity !=
                                                    ticket.ticketActivity.last)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15.0,
                                                            bottom: 0.0),
                                                    child: Container(
                                                      width: 2,
                                                      height: 30,
                                                      color: primarySwatch,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                SizedBox(height: 15.0),
                                DottedLine(
                                    dashLength: 2, dashColor: primarySwatch),
                                SizedBox(height: 15.0),
                                ticket.ticket.status == 'Open'
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    CommentDialog(
                                                        ticketId: ticket.id),
                                              );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 12, horizontal: 20),
                                              decoration: BoxDecoration(
                                                color: primarySwatch,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(Icons.comment,
                                                      color: Colors.white),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    'Comment',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              bool? confirm =
                                                  await showDialog<bool>(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  title: Text('Are you sure?'),
                                                  content: Text(
                                                      'Do you want to close this ticket?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context, false),
                                                      child: Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context, true),
                                                      child: Text('Confirm'),
                                                    ),
                                                  ],
                                                ),
                                              );

                                              if (confirm == true) {
                                                try {
                                                  final resp = await provider
                                                      .closedTicketById(
                                                          ticketId: ticket.id,
                                                          toggleLoading: false);
                                                  if (resp) {
                                                    if (mounted) {
                                                      Navigator.pop(
                                                          context, true);
                                                    }
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          "Error updating ticket",
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Colors.green,
                                                          ),
                                                        ),
                                                        backgroundColor:
                                                            Colors.white,
                                                      ),
                                                    );
                                                  }
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        e.toString(),
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                      backgroundColor:
                                                          Colors.white,
                                                    ),
                                                  );
                                                }
                                              }
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 12, horizontal: 20),
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(Icons.close,
                                                      color: Colors.white),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    'Close Ticket',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Center(
                                        child: GestureDetector(
                                          onTap: () async {
                                            await Provider.of<
                                                        NewTicketProvider>(
                                                    context,
                                                    listen: false)
                                                .fetchTicketCategories();

                                            await showDialog<bool>(
                                              context: context,
                                              builder: (context) {
                                                final provider1 = Provider.of<
                                                    NewTicketProvider>(context);
                                                List<Map<String, dynamic>>
                                                    assignTo =
                                                    provider1.userList
                                                        .map((assignTo) => {
                                                              'label':
                                                                  assignTo.text,
                                                              'value': assignTo
                                                                  .value,
                                                            })
                                                        .toList();

                                                return AlertDialog(
                                                  title: Text('Reopen Ticket'),
                                                  content: provider1.isLoading
                                                      ? Center(
                                                          child:
                                                              CircularProgressIndicator())
                                                      : Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            buildDropdown(
                                                              "Servity",
                                                              _selectedServity,
                                                              provider.servity,
                                                              (value) =>
                                                                  setState(() =>
                                                                      _selectedServity =
                                                                          value),
                                                            ),
                                                            buildDropdown(
                                                              "Priority",
                                                              _selectedPriority,
                                                              provider.priority,
                                                              (value) =>
                                                                  setState(() =>
                                                                      _selectedPriority =
                                                                          value),
                                                            ),
                                                            buildDropdownMap(
                                                              "Assign To",
                                                              _selectedassigntoType,
                                                              assignTo,
                                                              (value) =>
                                                                  setState(() =>
                                                                      _selectedassigntoType =
                                                                          value),
                                                            ),
                                                            SizedBox(height: 5),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context,
                                                                        false);
                                                                    setState(
                                                                        () {
                                                                      _selectedServity = ticket
                                                                          .ticket
                                                                          .severity;
                                                                      _selectedPriority = ticket
                                                                          .ticket
                                                                          .priority;
                                                                      _selectedassigntoType = ticket
                                                                          .ticket
                                                                          .assignToEmployeeId
                                                                          .toString();
                                                                    });
                                                                  },
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        accentColor,
                                                                    foregroundColor:
                                                                        Colors
                                                                            .white,
                                                                  ),
                                                                  child: Text(
                                                                      'Cancel'),
                                                                ),
                                                                SizedBox(
                                                                    width: 10),
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () async {
                                                                    bool?
                                                                        shouldProceed =
                                                                        await showDialog<
                                                                            bool>(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) =>
                                                                              AlertDialog(
                                                                        title: Text(
                                                                            'Confirm Reopen'),
                                                                        content:
                                                                            Text('Are you sure you want to reopen this ticket?'),
                                                                        actions: [
                                                                          TextButton(
                                                                            onPressed: () =>
                                                                                Navigator.pop(context, false),
                                                                            child:
                                                                                Text('No'),
                                                                          ),
                                                                          TextButton(
                                                                            onPressed: () =>
                                                                                Navigator.pop(context, true),
                                                                            child:
                                                                                Text('Yes'),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    );

                                                                    try {
                                                                      if (shouldProceed ==
                                                                          true) {
                                                                        if (ticket.ticket.status ==
                                                                            "Closed") {
                                                                          final resp =
                                                                              await provider.reopenTicketById(ticketId: ticket.id);

                                                                          await _onSubmit();
                                                                          if (resp) {
                                                                            if (mounted) {
                                                                              Navigator.pop(context, true);
                                                                            }
                                                                          }
                                                                        } else {
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(
                                                                            SnackBar(
                                                                              content: Text(
                                                                                'Error updating ticket',
                                                                                style: TextStyle(
                                                                                  fontSize: 18,
                                                                                  fontWeight: FontWeight.w400,
                                                                                  color: Colors.green,
                                                                                ),
                                                                              ),
                                                                              backgroundColor: Colors.white,
                                                                            ),
                                                                          );
                                                                        }
                                                                      }
                                                                    } catch (e) {
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                        SnackBar(
                                                                          content:
                                                                              Text(
                                                                            e.toString(),
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.w400,
                                                                              color: Colors.red,
                                                                            ),
                                                                          ),
                                                                          backgroundColor:
                                                                              Colors.white,
                                                                        ),
                                                                      );
                                                                    }
                                                                  },
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        primarySwatch,
                                                                    foregroundColor:
                                                                        Colors
                                                                            .white,
                                                                  ),
                                                                  child: Text(
                                                                      'Done'),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 20),
                                            decoration: BoxDecoration(
                                              color: primarySwatch,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.refresh,
                                                    color: Colors.white),
                                                SizedBox(width: 8),
                                                Text(
                                                  'Reopen Ticket',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ),
    );
  }
}

// 1. For Servity and Priority (String list)
Widget buildDropdown(String title, String? value, List<String> items,
    ValueChanged<String?> onChanged) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
            color: primarySwatch, fontSize: 16, fontWeight: FontWeight.w600),
      ),
      SizedBox(height: 5),
      CustomDropdown(
        value: value,
        items: items,
        hintText: "",
        onChanged: (val) => onChanged(val),
      ),
    ],
  );
}

// 2. For Assign To (List<Map<String, dynamic>>)
Widget buildDropdownMap(
  String title,
  String? selectedValue,
  List<Map<String, dynamic>> items,
  ValueChanged<String?> onChanged,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
            color: primarySwatch, fontSize: 16, fontWeight: FontWeight.w600),
      ),
      SizedBox(height: 5),
      DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: primarySwatch, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: primarySwatch, width: 2),
          ),
          filled: true,
          fillColor: cardBackgroundColor,
        ),
        isExpanded: true,
        items: items
            .map((item) => DropdownMenuItem<String>(
                  value: item["value"].toString(),
                  child: Text(item["label"]),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    ],
  );
}

// Method to show the image dialog
void _showImageDialog(BuildContext context, List<dynamic> attachedDocuments) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Attachment Documents'),
        content: SizedBox(
          height: 300,
          width: 300,
          child: PageView.builder(
            itemCount: attachedDocuments.length,
            itemBuilder: (context, index) {
              String imageUrl =
                  'http://45.117.153.90:5001/uploads/tickets/${attachedDocuments[index]}';
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                        ),
                      );
                    }
                  },
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    return Center(child: Icon(Icons.error, color: Colors.red));
                  },
                ),
              );
            },
          ),
        ),
        actions: [
          if (attachedDocuments.length > 1)
            TextButton(
              onPressed: () {},
              child: const Text('Previous'),
            ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
          if (attachedDocuments.length > 1)
            TextButton(
              onPressed: () {},
              child: const Text('Next'),
            ),
        ],
      );
    },
  );
}
