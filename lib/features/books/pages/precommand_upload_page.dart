import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../core/config/app_config.dart';
import '../bloc/books_bloc.dart';
import '../bloc/books_event.dart';
import '../bloc/books_state.dart';

class PrecommandUploadPage extends StatefulWidget {
  const PrecommandUploadPage({super.key});

  @override
  State<PrecommandUploadPage> createState() => _PrecommandUploadPageState();
}

class _PrecommandUploadPageState extends State<PrecommandUploadPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _tagsController = TextEditingController();

  String _selectedGenre = AppConfig.bookGenres.first;
  String _selectedLanguage = AppConfig.bookLanguages.first;
  DateTime? _releaseDate;
  File? _coverImage;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Precommand Book'),
      ),
      body: BlocListener<BooksBloc, BooksState>(
        listener: (context, state) {
          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Precommand book created successfully!')),
            );
            Navigator.pop(context);
          }
          if (state.isFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Upload failed')),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(Icons.schedule, size: 48, color: Colors.orange),
                        const SizedBox(height: 8),
                        Text(
                          'Precommand Book',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Text('Allow readers to preorder before release'),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),

                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Book Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value?.isEmpty == true ? 'Required' : null,
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                  validator: (value) => value?.isEmpty == true ? 'Required' : null,
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedGenre,
                        decoration: const InputDecoration(
                          labelText: 'Genre',
                          border: OutlineInputBorder(),
                        ),
                        items: AppConfig.bookGenres.map((genre) {
                          return DropdownMenuItem(value: genre, child: Text(genre));
                        }).toList(),
                        onChanged: (value) => setState(() => _selectedGenre = value!),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedLanguage,
                        decoration: const InputDecoration(
                          labelText: 'Language',
                          border: OutlineInputBorder(),
                        ),
                        items: AppConfig.bookLanguages.map((lang) {
                          return DropdownMenuItem(value: lang, child: Text(lang));
                        }).toList(),
                        onChanged: (value) => setState(() => _selectedLanguage = value!),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price (\$)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty == true) return 'Required';
                    if (double.tryParse(value!) == null) return 'Invalid price';
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                InkWell(
                  onTap: _selectReleaseDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Release Date',
                      border: OutlineInputBorder(),
                    ),
                    child: Text(
                      _releaseDate != null
                          ? '${_releaseDate!.day}/${_releaseDate!.month}/${_releaseDate!.year}'
                          : 'Select release date',
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _tagsController,
                  decoration: const InputDecoration(
                    labelText: 'Tags (comma separated)',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                Card(
                  child: InkWell(
                    onTap: _pickCoverImage,
                    child: Container(
                      height: 200,
                      child: _coverImage != null
                          ? Image.file(_coverImage!, fit: BoxFit.cover)
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image, size: 48),
                                Text('Tap to select cover image'),
                              ],
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                BlocBuilder<BooksBloc, BooksState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state.isLoading ? null : _submitPrecommand,
                      child: state.isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Create Precommand'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectReleaseDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() => _releaseDate = date);
    }
  }

  Future<void> _pickCoverImage() async {
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _coverImage = File(image.path));
    }
  }

  void _submitPrecommand() {
    if (_formKey.currentState!.validate() && _releaseDate != null) {
      final tags = _tagsController.text
          .split(',')
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toList();

      context.read<BooksBloc>().add(
        BookPrecommandRequested(
          title: _titleController.text,
          description: _descriptionController.text,
          genre: _selectedGenre,
          language: _selectedLanguage,
          price: double.parse(_priceController.text),
          releaseDate: _releaseDate!,
          coverImagePath: _coverImage?.path,
          tags: tags,
        ),
      );
    } else if (_releaseDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a release date')),
      );
    }
  }
}
