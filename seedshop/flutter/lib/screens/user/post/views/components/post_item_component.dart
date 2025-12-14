import 'package:ecommerce_sem4/models/user/cart/request/add_cart_request.dart';
import 'package:ecommerce_sem4/models/user/post/response/post_model.dart';
import 'package:ecommerce_sem4/models/user/product/response/product_model.dart';
import 'package:ecommerce_sem4/screens/user/post/views/post_detail_screen.dart';
import 'package:ecommerce_sem4/screens/user/product/views/product_detail_screen.dart';
import 'package:ecommerce_sem4/services/user/cart/cart_service.dart';
import 'package:ecommerce_sem4/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostItem extends StatelessWidget {
  final String? image;
  final String? name;
  final String? description;
  final Post? post;
  final imageUrl = "http://10.0.2.2:5069/images/";

  const PostItem(
      {super.key, this.image, this.name, this.description, this.post});
  String stripHtml(String htmlText) {
    if (htmlText.isEmpty) {
      return "";
    }

    // Remove HTML tags first
    String cleaned = htmlText.replaceAll(RegExp(r'<[^>]*>'), '');

    // Decode common HTML entities
    final Map<String, String> htmlEntities = {
      '&nbsp;': ' ',
      '&amp;': '&',
      '&lt;': '<',
      '&gt;': '>',
      '&quot;': '"',
      '&#39;': "'",
      '&aacute;': 'á',
      '&eacute;': 'é',
      '&iacute;': 'í',
      '&oacute;': 'ó',
      '&uacute;': 'ú',
      '&yacute;': 'ý',
      '&Aacute;': 'Á',
      '&Eacute;': 'É',
      '&Iacute;': 'Í',
      '&Oacute;': 'Ó',
      '&Uacute;': 'Ú',
      '&Yacute;': 'Ý',
      '&agrave;': 'à',
      '&egrave;': 'è',
      '&igrave;': 'ì',
      '&ograve;': 'ò',
      '&ugrave;': 'ù',
      '&Agrave;': 'À',
      '&Egrave;': 'È',
      '&Igrave;': 'Ì',
      '&Ograve;': 'Ò',
      '&Ugrave;': 'Ù',
      '&acirc;': 'â',
      '&ecirc;': 'ê',
      '&icirc;': 'î',
      '&ocirc;': 'ô',
      '&ucirc;': 'û',
      '&Acirc;': 'Â',
      '&Ecirc;': 'Ê',
      '&Icirc;': 'Î',
      '&Ocirc;': 'Ô',
      '&Ucirc;': 'Û',
      '&atilde;': 'ã',
      '&ntilde;': 'ñ',
      '&otilde;': 'õ',
      '&Atilde;': 'Ã',
      '&Ntilde;': 'Ñ',
      '&Otilde;': 'Õ',
      '&auml;': 'ä',
      '&euml;': 'ë',
      '&iuml;': 'ï',
      '&ouml;': 'ö',
      '&uuml;': 'ü',
      '&yuml;': 'ÿ',
      '&Auml;': 'Ä',
      '&Euml;': 'Ë',
      '&Iuml;': 'Ï',
      '&Ouml;': 'Ö',
      '&Uuml;': 'Ü',
    };

    htmlEntities.forEach((entity, char) {
      cleaned = cleaned.replaceAll(entity, char);
    });

    return cleaned.trim();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PostDetailScreen(post: post)));
      },
      child: Container(
        height: 120,
        margin: const EdgeInsets.all(5),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(6),
                width: 150,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                  shape: BoxShape.rectangle,
                ),
                child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(15)),
                    child: Image.network(
                      '$imageUrl${image!}',
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                          "assets/user/images/slide1.jpg"), // Optional error handling
                    )),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        stripHtml(name ?? ""),
                        maxLines: 2,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: blackColor,
                            overflow: TextOverflow.ellipsis),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        stripHtml(description ?? ""),
                        maxLines: 2,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
