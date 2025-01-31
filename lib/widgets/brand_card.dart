import 'package:flutter/material.dart';
import 'package:solitaire_picker/model/store_model.dart';

class BrandCard extends StatelessWidget {
  final String logo;
  final String name;
  final VoidCallback onTap;
  final StoreModel store;

  const BrandCard({
    super.key,
    required this.logo,
    required this.name,
    required this.onTap,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Hero(
              tag: store.id ?? '',
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 10,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.network(
                  logo,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error);
                  },
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              name,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
