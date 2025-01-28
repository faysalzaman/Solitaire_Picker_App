import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:solitaire_picker/cubit/picker/picker_cubit.dart';
import 'package:solitaire_picker/cubit/picker/picker_state.dart';
import 'package:solitaire_picker/utils/app_loading.dart';
import 'package:solitaire_picker/widgets/error_dialog.dart';
import 'package:solitaire_picker/widgets/success_dialog.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key, required this.pickerId});

  final String pickerId;

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int selectedRating = 1;
  final TextEditingController _commentsController = TextEditingController();

  void _showSuccessDialog(String title) {
    SuccessDialog.show(
      context,
      title: title,
      buttonText: 'OK',
    );
  }

  void _showErrorDialog(String title) {
    ErrorDialog.show(
      context,
      title: title,
      buttonText: 'OK',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<PickerCubit, PickerState>(
          listener: (context, state) {
            if (state is PickerReviewSuccessState) {
              _showSuccessDialog('Review submitted successfully');
              context.read<PickerCubit>().getPickers(1, 10);
              Navigator.pop(context);
            } else if (state is PickerReviewErrorState) {
              _showErrorDialog(state.message);
            }
          },
          builder: (context, state) {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Picker Rating & Review',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Select Star Rating',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          '(1 star to 5 star)',
                          style: TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 16),
                        RatingBar.builder(
                          initialRating: 1,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: false,
                          itemCount: 5,
                          itemSize: 32,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            setState(() {
                              selectedRating = rating.toInt();
                            });
                          },
                        ),
                        const SizedBox(height: 32),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Write your Comments',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade200),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade200,
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _commentsController,
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText: 'Write your Comments',
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          height: 40,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_commentsController.text.isEmpty) {
                                _showErrorDialog('Please write your comments');
                                return;
                              }

                              context.read<PickerCubit>().submitReview(
                                    widget.pickerId,
                                    double.parse(selectedRating.toString()),
                                    _commentsController.text,
                                  );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: state is PickerReviewLoadingState
                                ? const AppLoading(
                                    color: Colors.white,
                                    size: 20,
                                  )
                                : const Text(
                                    'Submit',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
