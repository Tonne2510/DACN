
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnswerComment extends StatefulWidget{
  final String? accountName;
  final String? content;
  final DateTime createdAt;
  final String? avatar;

  const AnswerComment({super.key,  this.accountName,  this.content, required this.createdAt, this.avatar});

  @override
  State<StatefulWidget> createState() => _AnwserComment();
}

class _AnwserComment extends State<AnswerComment>{
  final imageUrl = "http://10.0.2.2:5069/images/";


  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Shadow color
            spreadRadius: 2, // Spread radius
            blurRadius: 10, // Blur radius
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(50),
              // color: const Color(),
              border: Border.all(width: 1,color: Colors.black12, strokeAlign: BorderSide.strokeAlignOutside, style: BorderStyle.solid)
            ),
             child: ClipRRect(
                 borderRadius:  BorderRadius.circular(50),
                 child: Image.network(
                   '$imageUrl${(widget.avatar!=null?widget.avatar:"1.png")}',
                   // height: 100,
                   fit: BoxFit.fill,
                   errorBuilder: (context, error, stackTrace) => Image.asset("assets/user/images/avatar-1.png"), // Optional error handling
                 )
             ),
          ),

         Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
               widget.accountName!,
                style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(
                height: 1,
              ),
              Text(
                DateFormat('dd/MM/yyyy').format(widget.createdAt)
                ,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  fontStyle: FontStyle.italic
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                widget.content!,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ],
          ),
         )
        ],
      ),
    );
  }
}