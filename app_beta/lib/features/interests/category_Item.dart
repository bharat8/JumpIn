import 'dart:core';

import 'package:flutter/material.dart';

class Item {
  Icon icon;
  int rank;
  String categoryName;
  Item(this.icon, this.rank, this.categoryName);
}

class SubcategoryItem {
  String subcategoryname;
  int rank;
  bool isSelected;
  SubcategoryItem(
    this.subcategoryname,
    this.rank,
    this.isSelected,
  );
}

final List<Item> InterestCategory = <Item>[
  Item(Icon(Icons.sports), 0, 'Outdoor Sports'),
  Item(Icon(Icons.music_note_rounded), 1, 'Music'),
  Item(Icon(Icons.movie), 2, 'Movies'),
  Item(Icon(Icons.book), 3, 'Books'),
  Item(Icon(Icons.backpack_rounded), 4, 'Hobbies'),
  Item(Icon(Icons.gamepad_rounded), 5, 'Games'),
  Item(Icon(Icons.menu_book_rounded), 6, 'Examination'),
  Item(Icon(Icons.event), 7, 'Events'),
];

List<Item> InterestCategorySelected = <Item>[];

List<List<SubcategoryItem>> superSubcategory = [
  [
    SubcategoryItem('Cricket', 0, false),
    SubcategoryItem('Football', 1, false),
    SubcategoryItem('Tennis', 2, false),
    SubcategoryItem('Badminton', 3, false),
    SubcategoryItem('Hockey', 4, false),
    SubcategoryItem('Athletics', 5, false),
    SubcategoryItem('Basketball', 6, false),
    SubcategoryItem('Table-Tennis', 7, false),
    SubcategoryItem('Squash', 8, false),
    SubcategoryItem('Golf', 9, false),
    SubcategoryItem('Motosports', 10, false),
    //SubcategoryItem('Volleyball', 11, false)
  ],
  [
    SubcategoryItem('Bollywood', 0, false),
    SubcategoryItem('Classical', 1, false),
    SubcategoryItem('Folk', 2, false),
    SubcategoryItem('Soulful', 3, false),
    SubcategoryItem('Pop', 4, false),
    SubcategoryItem('Rock', 5, false),
    SubcategoryItem('RAP', 6, false),
    SubcategoryItem('Country', 7, false),
    SubcategoryItem('Kpop', 8, false),
    SubcategoryItem('Jazz', 9, false),
    SubcategoryItem('Heavy-Metal', 10, false),
    //SubcategoryItem('Death-Metal', 11, false),
  ],
  [
    SubcategoryItem('Bollywood', 0, false),
    SubcategoryItem('Hollywood', 1, false),
    SubcategoryItem('Action', 2, false),
    SubcategoryItem('Anime', 3, false),
    SubcategoryItem('Comedy', 4, false),
    SubcategoryItem('Crime', 5, false),
    SubcategoryItem('Drama', 6, false),
    SubcategoryItem('Horror', 7, false),
    SubcategoryItem('Sci-Fi', 8, false),
    SubcategoryItem('Romance', 9, false),
    SubcategoryItem('Thriller', 10, false),
    //SubcategoryItem('Fantasy', 11, false)
  ],
  [
    SubcategoryItem('Comics', 0, false),
    SubcategoryItem('Non-Fiction', 1, false),
    SubcategoryItem('Magazines', 2, false),
    SubcategoryItem('Manga', 3, false),
    SubcategoryItem('Poems', 4, false),
    SubcategoryItem('ShortStories', 5, false),
    SubcategoryItem('Biography', 6, false),
    SubcategoryItem('Self-help', 7, false),
    SubcategoryItem('Fan-Fiction', 8, false),
    SubcategoryItem('Mystery', 9, false),
    SubcategoryItem('Mythology', 10, false)
  ],
  [
    SubcategoryItem('Photography', 0, false),
    SubcategoryItem('Dancing', 1, false),
    SubcategoryItem('Singing', 2, false),
    SubcategoryItem('Writing', 3, false),
    SubcategoryItem('Instruments', 4, false),
    SubcategoryItem('Painting', 5, false),
    SubcategoryItem('Reading', 6, false),
    SubcategoryItem('Stand-up-Comedy', 7, false),
    SubcategoryItem('Shopping', 8, false),
    SubcategoryItem('Drawing', 9, false),
    SubcategoryItem('Baking', 10, false)
  ],
  [
    SubcategoryItem('Bowling', 0, false),
    SubcategoryItem('Card-Games', 1, false),
    SubcategoryItem('Ludo', 2, false),
    SubcategoryItem('Snakeladder', 3, false),
    SubcategoryItem('Monopoly', 4, false),
    SubcategoryItem('Pictionary', 5, false),
    SubcategoryItem('Cluedo', 6, false),
    SubcategoryItem('Carrom', 7, false),
    SubcategoryItem('Fifa', 8, false),
    SubcategoryItem('Call of Duty', 9, false),
    SubcategoryItem('Halo', 10, false)
  ],
  [
    SubcategoryItem('CLAT', 0, false),
    SubcategoryItem('JEE', 1, false),
    SubcategoryItem('NEET', 2, false),
    SubcategoryItem('CAT', 3, false),
    SubcategoryItem('NPAT', 4, false),
    SubcategoryItem('ACT', 5, false),
    SubcategoryItem('SAT', 6, false),
    SubcategoryItem('GMAT', 7, false),
    SubcategoryItem('Actuaries', 8, false),
    SubcategoryItem('IELTS', 9, false),
    SubcategoryItem('CFA', 10, false),
    // SubcategoryItem('CA', 11, false)
  ],
  [
    SubcategoryItem('CollegeFests', 0, false),
    SubcategoryItem('Stand-up-comedy', 1, false),
    SubcategoryItem('Spoken-Word-Poetry', 2, false),
    SubcategoryItem('Magic', 3, false),
    SubcategoryItem('Theatre', 4, false),
    SubcategoryItem('Concert', 5, false),
    SubcategoryItem('Sports-Matches', 6, false),
    SubcategoryItem('Movies', 7, false),
    SubcategoryItem('Songs', 8, false),
    SubcategoryItem('Festivals', 9, false),
    SubcategoryItem('Book-Reading', 10, false),
    //  SubcategoryItem('Quizzes', 11, false)
  ]
];
List<SubcategoryItem> SelectedInterestSubcategory = [];
