import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../books/bloc/books_bloc.dart';
import '../../books/bloc/books_event.dart';
import '../../books/bloc/books_state.dart';
import '../widgets/book_card.dart';
import '../widgets/genre_filter_chips.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/upcoming_messages_banner.dart';
import '../../books/pages/book_upload_page.dart';
import '../../books/pages/precommand_upload_page.dart';
import '../../profile/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _isFabOpen = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _scrollController.addListener(_onScroll);
    
    // Load initial data
    context.read<BooksBloc>().add(const BooksLoadRequested());
    context.read<BooksBloc>().add(UpcomingMessagesLoadRequested());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      final booksState = context.read<BooksBloc>().state;
      if (!booksState.hasReachedMax && !booksState.isLoading) {
        context.read<BooksBloc>().add(BooksLoadRequested(
          page: booksState.currentPage + 1,
          genre: booksState.currentGenre,
          language: booksState.currentLanguage,
          searchQuery: booksState.currentSearchQuery,
        ));
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            title: const Text('GITABU'),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ),
                  );
                },
                icon: const CircleAvatar(
                  radius: 16,
                  child: Text('U', style: TextStyle(fontSize: 14)),
                ),
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(HugeIcons.strokeRoundedHome09), text: 'Home'),
                Tab(icon: Icon(HugeIcons.strokeRoundedSearchArea), text: 'Explore'),
                Tab(icon: Icon(HugeIcons.strokeRoundedDownloadSquare01), text: 'Downloads'),
                Tab(icon: Icon(HugeIcons.strokeRoundedShoppingBasketFavorite02), text: 'Favorites'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildHomeTab(),
              _buildExploreTab(),
              _buildDownloadsTab(),
              _buildFavoritesTab(),
            ],
          ),
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isFabOpen) ...[
                FloatingActionButton.small(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PrecommandUploadPage(),
                      ),
                    );
                    setState(() => _isFabOpen = false);
                  },
                  heroTag: "precommand",
                  child: const Icon(Icons.schedule),
                ),
                const SizedBox(height: 8),
                FloatingActionButton.small(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BookUploadPage(),
                      ),
                    );
                    setState(() => _isFabOpen = false);
                  },
                  heroTag: "upload",
                  child: const Icon(Icons.upload_file),
                ),
                const SizedBox(height: 8),
              ],
              FloatingActionButton(
                onPressed: () => setState(() => _isFabOpen = !_isFabOpen),
                child: Icon(_isFabOpen ? Icons.close : Icons.add),
              ),
            ],
          ),
        );
  }

  Widget _buildHomeTab() {
    return Column(
      children: [
        const UpcomingMessagesBanner(),
        const SearchBarWidget(),
        const GenreFilterChips(),
        Expanded(
          child: BlocBuilder<BooksBloc, BooksState>(
            builder: (context, state) {
              if (state.isLoading && state.books.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.isFailure) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.errorMessage ?? 'Something went wrong'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<BooksBloc>().add(BooksRefreshRequested());
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (state.isEmpty) {
                return const Center(
                  child: Text('No books found'),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<BooksBloc>().add(BooksRefreshRequested());
                },
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: state.books.length + (state.isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= state.books.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    return BookCard(book: state.books[index]);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }


  Widget _buildExploreTab() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'All Books'),
              Tab(text: 'Precommand'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildAllBooksView(),
                _buildPrecommandView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllBooksView() {
    return const Center(
      child: Text('All Books - Coming Soon'),
    );
  }

  Widget _buildPrecommandView() {
    return BlocBuilder<BooksBloc, BooksState>(
      builder: (context, state) {
        if (state.precommandBooks.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.schedule, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No precommand books available'),
                SizedBox(height: 8),
                Text('Check back later for upcoming releases!'),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: state.precommandBooks.length,
          itemBuilder: (context, index) {
            final book = state.precommandBooks[index];
            return Card(
              child: ListTile(
                leading: book.coverImageUrl != null
                    ? Image.network(book.coverImageUrl!, width: 50, fit: BoxFit.cover)
                    : const Icon(Icons.book, size: 50),
                title: Text(book.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('By ${book.authorName}'),
                    Text('Release: ${book.releaseDate.day}/${book.releaseDate.month}/${book.releaseDate.year}'),
                    Text('${book.preorders} preorders'),
                  ],
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    // TODO: Handle preorder
                  },
                  child: Text('\$${book.price.toStringAsFixed(2)}'),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDownloadsTab() {
    return BlocBuilder<BooksBloc, BooksState>(
      builder: (context, state) {
        if (state.downloadedBooks.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.download, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No downloaded books'),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: state.downloadedBooks.length,
          itemBuilder: (context, index) {
            return BookCard(
              book: state.downloadedBooks[index],
              isDownloaded: true,
            );
          },
        );
      },
    );
  }

  Widget _buildFavoritesTab() {
    return const Center(
      child: Text('Favorites - Coming Soon'),
    );
  }
}