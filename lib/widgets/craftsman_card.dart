import 'package:flutter/material.dart';
import 'package:crafts_portal/models/user_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CraftsmanCard extends StatelessWidget {
  final UserModel craftsman;
  final VoidCallback? onTap;

  const CraftsmanCard({
    super.key,
    required this.craftsman,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Profile Image
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: craftsman.profileImageUrl != null
                    ? NetworkImage(craftsman.profileImageUrl!)
                    : null,
                child: craftsman.profileImageUrl == null
                    ? Icon(
                        Icons.person,
                        size: 30,
                        color: Colors.grey.shade400,
                      )
                    : null,
              ),
              
              const SizedBox(width: 16),
              
              // Craftsman Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      craftsman.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Craft Category
                    if (craftsman.craftCategory != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          craftsman.craftCategory!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    
                    const SizedBox(height: 8),
                    
                    // Bio
                    if (craftsman.bio != null && craftsman.bio!.isNotEmpty)
                      Text(
                        craftsman.bio!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          fontFamily: 'Poppins',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    
                    const SizedBox(height: 8),
                    
                    // Location and Rating
                    Row(
                      children: [
                        if (craftsman.location != null) ...[
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              craftsman.location!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                                fontFamily: 'Poppins',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                        const Spacer(),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '4.5', // TODO: Get actual rating
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Action Button
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      // TODO: Navigate to craftsman profile
                    },
                    icon: const Icon(Icons.visibility),
                    tooltip: 'View Profile',
                  ),
                  const SizedBox(height: 4),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Start chat with craftsman
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      minimumSize: const Size(0, 0),
                    ),
                    child: const Text(
                      'Chat',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 