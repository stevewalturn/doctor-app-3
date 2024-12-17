import 'package:flutter/material.dart';
import 'package:my_app/core/theme/app_colors.dart';
import 'package:my_app/core/theme/app_typography.dart';
import 'package:my_app/models/patient.dart';
import 'package:my_app/widgets/custom_card.dart';
import 'package:intl/intl.dart';

class PatientCard extends StatelessWidget {
  final Patient patient;
  final VoidCallback? onTap;

  const PatientCard({
    Key? key,
    required this.patient,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(
                  patient.name.substring(0, 1).toUpperCase(),
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient.name,
                      style: AppTypography.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID: ${patient.id}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            Icons.calendar_today,
            'DOB: ${DateFormat('MMM dd, yyyy').format(patient.dateOfBirth)}',
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            Icons.phone,
            patient.phoneNumber,
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            Icons.email,
            patient.email,
          ),
          if (patient.bloodType != null) ...[
            const SizedBox(height: 8),
            _buildInfoRow(
              Icons.opacity,
              'Blood Type: ${patient.bloodType}',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.textLight,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
