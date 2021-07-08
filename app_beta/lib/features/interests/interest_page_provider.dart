import 'dart:convert';

import 'package:JumpIn/core/utils/route_constants.dart';
import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class InterestPageProvider extends ChangeNotifier {
  Map<String, bool> _categoriesMap = Map.fromIterable([
    "Outdoor Sports",
    "Indoor Sports",
    "Health & Fitness",
    "Travel & Adventure",
    "Food & Drinks",
    "Games",
    "Academic interests",
    "Career & Professional interests",
    "Amusement",
    "Hobbies",
    "Causes passionate about",
    "Fandoms",
    "Competitive Exams",
    "Miscellaneous"
  ], key: (item) => item.toString(), value: (item) => false);

  Map<String, dynamic> _subCategoriesMap = {
    "Outdoor Sports": {
      "Cricket": [
        false,
        "assets/images/Onboarding/Interests/outdoor-sports/cricket.jpg"
      ],
      "Football": [
        false,
        "assets/images/Onboarding/Interests/outdoor-sports/football.jpg"
      ],
      "Tennis": [
        false,
        "assets/images/Onboarding/Interests/outdoor-sports/tennis.jpg"
      ],
      "Hockey": [
        false,
        "assets/images/Onboarding/Interests/outdoor-sports/hockey.jpg"
      ],
      "Athletics": [
        false,
        "assets/images/Onboarding/Interests/outdoor-sports/athletics.jpg"
      ],
      "Basketball": [
        false,
        "assets/images/Onboarding/Interests/outdoor-sports/basketball.jpg"
      ],
      "Swimming": [
        false,
        "assets/images/Onboarding/Interests/outdoor-sports/swimming.jpg"
      ],
      "Volleyball": [
        false,
        "assets/images/Onboarding/Interests/outdoor-sports/volleyball.jpg"
      ],
      "Motorsports": [
        false,
        "assets/images/Onboarding/Interests/outdoor-sports/motorsports.jpg"
      ],
      "Golf": [
        false,
        "assets/images/Onboarding/Interests/outdoor-sports/golf.jpg"
      ],
      "Shooting": [
        false,
        "assets/images/Onboarding/Interests/outdoor-sports/shooting.jpg"
      ],
      "Archery": [
        false,
        "assets/images/Onboarding/Interests/outdoor-sports/archery.jpg"
      ],
      "Gymnastics": [
        false,
        "assets/images/Onboarding/Interests/outdoor-sports/gymnastics.jpg"
      ],
      "Martial arts": [
        false,
        "assets/images/Onboarding/Interests/outdoor-sports/martial-arts.jpg"
      ],
    },
    "Indoor Sports": {
      "Badminton": [
        false,
        "assets/images/Onboarding/Interests/indoor-sports/badminton.jpg"
      ],
      "Table Tennis": [
        false,
        "assets/images/Onboarding/Interests/indoor-sports/table-tennis.jpg"
      ],
      "Squash": [
        false,
        "assets/images/Onboarding/Interests/indoor-sports/squash.jpg"
      ],
      "Pool": [
        false,
        "assets/images/Onboarding/Interests/indoor-sports/pool.jpg"
      ],
      "Snooker": [
        false,
        "assets/images/Onboarding/Interests/indoor-sports/snooker.jpg"
      ],
      "Billiards": [
        false,
        "assets/images/Onboarding/Interests/indoor-sports/billiards.jpg"
      ],
      "Kabaddi": [
        false,
        "assets/images/Onboarding/Interests/indoor-sports/kabaddi.jpg"
      ],
      "Chess": [
        false,
        "assets/images/Onboarding/Interests/indoor-sports/chess.jpg"
      ],
      "Carrom": [
        false,
        "assets/images/Onboarding/Interests/indoor-sports/carrom.jpg"
      ],
      "Bowling": [
        false,
        "assets/images/Onboarding/Interests/indoor-sports/bowling.jpg"
      ],
      "Go karting": [
        false,
        "assets/images/Onboarding/Interests/indoor-sports/go-karting.jpg"
      ],
    },
    "Health & Fitness": {
      "Cycling": [
        false,
        "assets/images/Onboarding/Interests/health-&-fitness/cycling.jpg"
      ],
      "Walking": [
        false,
        "assets/images/Onboarding/Interests/health-&-fitness/walking.jpg"
      ],
      "Yoga": [
        false,
        "assets/images/Onboarding/Interests/health-&-fitness/yoga.jpg"
      ],
      "Jogging": [
        false,
        "assets/images/Onboarding/Interests/health-&-fitness/jogging.jpg"
      ],
      "Running": [
        false,
        "assets/images/Onboarding/Interests/health-&-fitness/running.jpg"
      ],
      "Gymming": [
        false,
        "assets/images/Onboarding/Interests/health-&-fitness/gymming.jpg"
      ],
      "Zumba": [
        false,
        "assets/images/Onboarding/Interests/health-&-fitness/zumba.jpg"
      ],
      "Pilates": [
        false,
        "assets/images/Onboarding/Interests/health-&-fitness/pilates.jpg"
      ],
      "Aerobics": [
        false,
        "assets/images/Onboarding/Interests/health-&-fitness/aerobics.jpg"
      ],
      "Rock climbing": [
        false,
        "assets/images/Onboarding/Interests/health-&-fitness/rock-climbing.jpg"
      ],
      "Body building": [
        false,
        "assets/images/Onboarding/Interests/health-&-fitness/body-building.jpg"
      ],
      "Nutrition": [
        false,
        "assets/images/Onboarding/Interests/health-&-fitness/nutrition.jpg"
      ],
    },
    "Travel & Adventure": {
      "Camping": [
        false,
        "assets/images/Onboarding/Interests/travel-&-adventure/camping.jpg"
      ],
      "Hiking": [
        false,
        "assets/images/Onboarding/Interests/travel-&-adventure/hiking.jpg"
      ],
      "Trekking": [
        false,
        "assets/images/Onboarding/Interests/travel-&-adventure/trekking.jpg"
      ],
      "Fishing": [
        false,
        "assets/images/Onboarding/Interests/travel-&-adventure/fishing.jpg"
      ],
      "Bungee Jumping": [
        false,
        "assets/images/Onboarding/Interests/travel-&-adventure/bungee-jumping.jpg"
      ],
      "Sky Diving": [
        false,
        "assets/images/Onboarding/Interests/travel-&-adventure/sky-diving.jpg"
      ],
      "Paragliding": [
        false,
        "assets/images/Onboarding/Interests/travel-&-adventure/paragliding.jpg"
      ],
      "Water Sports": [
        false,
        "assets/images/Onboarding/Interests/travel-&-adventure/water-sports.jpg"
      ],
      "Safari": [
        false,
        "assets/images/Onboarding/Interests/travel-&-adventure/safari.jpg"
      ],
      "Beach": [
        false,
        "assets/images/Onboarding/Interests/travel-&-adventure/beach.jpg"
      ],
      "Wildlife": [
        false,
        "assets/images/Onboarding/Interests/travel-&-adventure/wildlife.jpg"
      ],
      "Desert": [
        false,
        "assets/images/Onboarding/Interests/travel-&-adventure/desert.jpg"
      ],
      "Snow": [
        false,
        "assets/images/Onboarding/Interests/travel-&-adventure/snow.jpg"
      ],
      "Nature": [
        false,
        "assets/images/Onboarding/Interests/travel-&-adventure/nature.jpg"
      ],
      "Party Festivals": [
        false,
        "assets/images/Onboarding/Interests/travel-&-adventure/party-festivals.jpg"
      ],
    },
    "Food & Drinks": {
      "North Indian": [
        false,
        "assets/images/Onboarding/Interests/foods-&-drinks/north-indian.jpg"
      ],
      "South Indian": [
        false,
        "assets/images/Onboarding/Interests/foods-&-drinks/south-indian.jpg"
      ],
      "Italian": [
        false,
        "assets/images/Onboarding/Interests/foods-&-drinks/italian.jpg"
      ],
      "Chinese": [
        false,
        "assets/images/Onboarding/Interests/foods-&-drinks/chinese.jpg"
      ],
      "Japanese": [
        false,
        "assets/images/Onboarding/Interests/foods-&-drinks/japanese.jpg"
      ],
      "Thai": [
        false,
        "assets/images/Onboarding/Interests/foods-&-drinks/thai.jpg"
      ],
      "Mexican": [
        false,
        "assets/images/Onboarding/Interests/foods-&-drinks/mexican.jpg"
      ],
      "Lebanese": [
        false,
        "assets/images/Onboarding/Interests/foods-&-drinks/lebanese.jpg"
      ],
      "Patisseries": [
        false,
        "assets/images/Onboarding/Interests/foods-&-drinks/patisseries.jpg"
      ],
      "Ice Cream Parlours": [
        false,
        "assets/images/Onboarding/Interests/foods-&-drinks/ice-cream-parlours.jpg"
      ],
      "Healthy food": [
        false,
        "assets/images/Onboarding/Interests/foods-&-drinks/healthy-food.jpg"
      ],
      "Seafood": [
        false,
        "assets/images/Onboarding/Interests/foods-&-drinks/seafood.jpg"
      ],
      "Wine-tasting": [
        false,
        "assets/images/Onboarding/Interests/foods-&-drinks/wine-tasting.jpg"
      ],
      "Barbeque": [
        false,
        "assets/images/Onboarding/Interests/foods-&-drinks/barbeque.jpg"
      ]
    },
    "Games": {
      "Console": [
        false,
        "assets/images/Onboarding/Interests/games/console.jpg"
      ],
      "Board": [false, "assets/images/Onboarding/Interests/games/board.jpg"],
      "Mobile": [false, "assets/images/Onboarding/Interests/games/mobile.jpg"],
      "Card": [false, "assets/images/Onboarding/Interests/games/card.jpg"],
      "Casino": [false, "assets/images/Onboarding/Interests/games/casino.jpg"],
      "Arcade": [false, "assets/images/Onboarding/Interests/games/arcade.jpg"],
      "Laser tag": [
        false,
        "assets/images/Onboarding/Interests/games/laser-tag.jpg"
      ],
      "Fantasy Sports": [
        false,
        "assets/images/Onboarding/Interests/games/fantasy.jpg"
      ],
    },
    "Academic interests": {
      "History": [
        false,
        "assets/images/Onboarding/Interests/academic/history.jpg"
      ],
      "Geography": [
        false,
        "assets/images/Onboarding/Interests/academic/geography.jpg"
      ],
      "Science": [
        false,
        "assets/images/Onboarding/Interests/academic/science.jpg"
      ],
      "Maths": [false, "assets/images/Onboarding/Interests/academic/maths.jpg"],
      "Literature": [
        false,
        "assets/images/Onboarding/Interests/academic/literature.jpg"
      ],
      "Economics": [
        false,
        "assets/images/Onboarding/Interests/academic/economics.jpg"
      ],
      "Finance": [
        false,
        "assets/images/Onboarding/Interests/academic/finance.jpg"
      ],
      "Psychology": [
        false,
        "assets/images/Onboarding/Interests/academic/psychology.jpg"
      ],
      "Computer Science": [
        false,
        "assets/images/Onboarding/Interests/academic/computer-science.jpg"
      ],
      "Politics": [
        false,
        "assets/images/Onboarding/Interests/academic/politics.jpg"
      ],
      "Law": [false, "assets/images/Onboarding/Interests/academic/law.jpg"],
      "Astronomy": [
        false,
        "assets/images/Onboarding/Interests/academic/astronomy.jpg"
      ],
      "Journalism": [
        false,
        "assets/images/Onboarding/Interests/academic/journalism.jpg"
      ],
      "Medicine": [
        false,
        "assets/images/Onboarding/Interests/academic/medicine.jpg"
      ],
      "Commerce": [
        false,
        "assets/images/Onboarding/Interests/academic/commerce.jpg"
      ],
      "Statistics": [
        false,
        "assets/images/Onboarding/Interests/academic/statistics.jpg"
      ],
      "Data Science": [
        false,
        "assets/images/Onboarding/Interests/academic/data-science.jpg"
      ],
      "Coding": [
        false,
        "assets/images/Onboarding/Interests/academic/coding.jpg"
      ],
    },
    "Career & Professional interests": {
      "Architecture": [
        false,
        "assets/images/Onboarding/Interests/career/architecture.jpg"
      ],
      "Interior Designing": [
        false,
        "assets/images/Onboarding/Interests/career/interior-designing.jpg"
      ],
      "Software Development": [
        false,
        "assets/images/Onboarding/Interests/career/software-development.jpg"
      ],
      "Fashion Designing": [
        false,
        "assets/images/Onboarding/Interests/career/fashion-designing.png"
      ],
      "Hospitality Management": [
        false,
        "assets/images/Onboarding/Interests/career/hospitality-management.jpg"
      ],
      "Accounting": [
        false,
        "assets/images/Onboarding/Interests/career/accounting.jpg"
      ],
      "Entrepreneurship": [
        false,
        "assets/images/Onboarding/Interests/career/entrepreneurship.jpg"
      ],
      "Chartered Accountant": [
        false,
        "assets/images/Onboarding/Interests/career/chartered-accountant.jpg"
      ],
      "MBA": [false, "assets/images/Onboarding/Interests/career/mba.jpg"],
      "CFA": [false, "assets/images/Onboarding/Interests/career/cfa.jpg"],
      "MBBS": [false, "assets/images/Onboarding/Interests/career/mbbs.jpg"],
      "Fine Arts": [
        false,
        "assets/images/Onboarding/Interests/career/fine-arts.jpg"
      ],
      "Performing Arts": [
        false,
        "assets/images/Onboarding/Interests/career/performing-arts.jpg"
      ],
      "Music": [false, "assets/images/Onboarding/Interests/career/music.jpg"],
      "Writing": [
        false,
        "assets/images/Onboarding/Interests/career/writing.jpg"
      ],
      "Comedy": [false, "assets/images/Onboarding/Interests/career/comedy.jpg"],
      "Acting": [false, "assets/images/Onboarding/Interests/career/acting.jpg"],
      "Directing": [
        false,
        "assets/images/Onboarding/Interests/career/directing.jpg"
      ],
      "Chef/Cooking": [
        false,
        "assets/images/Onboarding/Interests/career/chef.jpg"
      ],
      "Armed Forces": [
        false,
        "assets/images/Onboarding/Interests/career/armed-forces.jpg"
      ],
      "Hair Styling": [
        false,
        "assets/images/Onboarding/Interests/career/hair-styling.jpg"
      ],
      "Graphic Designing": [
        false,
        "assets/images/Onboarding/Interests/career/graphic-designing.jpg"
      ],
      "Consultancy": [
        false,
        "assets/images/Onboarding/Interests/career/consultancy.jpg"
      ],
      "Counselling": [
        false,
        "assets/images/Onboarding/Interests/career/counselling.jpg"
      ],
      "Actuaries": [
        false,
        "assets/images/Onboarding/Interests/career/actuaries.jpg"
      ],
      "Editing": [
        false,
        "assets/images/Onboarding/Interests/career/editing.jpg"
      ],
      "Agriculture": [
        false,
        "assets/images/Onboarding/Interests/career/agriculture.jpg"
      ],
      "Startup": [
        false,
        "assets/images/Onboarding/Interests/career/startup.jpg"
      ],
    },
    "Amusement": {
      "College Fests": [
        false,
        "assets/images/Onboarding/Interests/entertainment/college-fests.jfif"
      ],
      "Stand up comedy": [
        false,
        "assets/images/Onboarding/Interests/entertainment/stand-up.jpg"
      ],
      "Open mics": [
        false,
        "assets/images/Onboarding/Interests/entertainment/open-mics.jpg"
      ],
      "Magic": [
        false,
        "assets/images/Onboarding/Interests/entertainment/magic.jpg"
      ],
      "Theatre": [
        false,
        "assets/images/Onboarding/Interests/entertainment/theatre.jpg"
      ],
      "Concert": [
        false,
        "assets/images/Onboarding/Interests/entertainment/concert.jpg"
      ],
      "Sports Matches": [
        false,
        "assets/images/Onboarding/Interests/entertainment/sports-matches.jpg"
      ],
      "Movies": [
        false,
        "assets/images/Onboarding/Interests/entertainment/movies.jpg"
      ],
      "Shows": [
        false,
        "assets/images/Onboarding/Interests/entertainment/shows.jpg"
      ],
      "Seminars": [
        false,
        "assets/images/Onboarding/Interests/entertainment/seminars.jpg"
      ],
      "Theme Parks": [
        false,
        "assets/images/Onboarding/Interests/entertainment/theme-parks.jpg"
      ],
      "Festivals": [
        false,
        "assets/images/Onboarding/Interests/entertainment/festivals.jpg"
      ],
      "Book Reading": [
        false,
        "assets/images/Onboarding/Interests/entertainment/book-reading.jpg"
      ],
      "Quizzes": [
        false,
        "assets/images/Onboarding/Interests/entertainment/quizzes.jfif"
      ],
      "Tours": [
        false,
        "assets/images/Onboarding/Interests/entertainment/tours.jpg"
      ],
      "Exhibition": [
        false,
        "assets/images/Onboarding/Interests/entertainment/exhibition.jpg"
      ],
    },
    "Hobbies": {
      "Photography": [
        false,
        "assets/images/Onboarding/Interests/hobbies/photography.jpg"
      ],
      "Dancing": [
        false,
        "assets/images/Onboarding/Interests/hobbies/dancing.jpg"
      ],
      "Singing": [
        false,
        "assets/images/Onboarding/Interests/hobbies/singing.jpg"
      ],
      "Playing instruments": [
        false,
        "assets/images/Onboarding/Interests/hobbies/playing-instruments.jpg"
      ],
      "Reading": [
        false,
        "assets/images/Onboarding/Interests/hobbies/reading.jpg"
      ],
      "Painting": [
        false,
        "assets/images/Onboarding/Interests/hobbies/painting.jpg"
      ],
      "Watching Movies and shows": [
        false,
        "assets/images/Onboarding/Interests/hobbies/movies.jpg"
      ],
      "Shopping": [
        false,
        "assets/images/Onboarding/Interests/hobbies/shopping.jpg"
      ],
      "Drawing": [
        false,
        "assets/images/Onboarding/Interests/hobbies/drawing.jpg"
      ],
      "Baking": [
        false,
        "assets/images/Onboarding/Interests/hobbies/baking.jpg"
      ],
      "Cooking": [
        false,
        "assets/images/Onboarding/Interests/hobbies/cooking.jpg"
      ],
      "Birdwatching": [
        false,
        "assets/images/Onboarding/Interests/hobbies/bird-watching.jpg"
      ],
      "Stargazing": [
        false,
        "assets/images/Onboarding/Interests/hobbies/stargazing.jpg"
      ],
      "Clubbing": [
        false,
        "assets/images/Onboarding/Interests/hobbies/clubbing.jpg"
      ],
      "Debating": [
        false,
        "assets/images/Onboarding/Interests/hobbies/debating.png"
      ],
      "Quizzing": [
        false,
        "assets/images/Onboarding/Interests/hobbies/quizzes.jfif"
      ],
      "Driving": [
        false,
        "assets/images/Onboarding/Interests/hobbies/driving.jpg"
      ],
      "Grounds keeping": [
        false,
        "assets/images/Onboarding/Interests/hobbies/gardening.jpg"
      ],
      "Collecting items": [
        false,
        "assets/images/Onboarding/Interests/hobbies/collecting-items.jpg"
      ],
      "Pottery": [
        false,
        "assets/images/Onboarding/Interests/hobbies/pottery.jpg"
      ],
    },
    "Causes passionate about": {
      "Mental health": [
        false,
        "assets/images/Onboarding/Interests/causes-passionate-about/mental-health.jpg"
      ],
      "LGBTQ+": [
        false,
        "assets/images/Onboarding/Interests/causes-passionate-about/lgbtq+.jpg"
      ],
      "Feminism": [
        false,
        "assets/images/Onboarding/Interests/causes-passionate-about/feminism.jpg"
      ],
      "Poverty": [
        false,
        "assets/images/Onboarding/Interests/causes-passionate-about/poverty.jpg"
      ],
      "Child labour": [
        false,
        "assets/images/Onboarding/Interests/causes-passionate-about/child-labour.jpg"
      ],
      "Casteism": [
        false,
        "assets/images/Onboarding/Interests/causes-passionate-about/casteism.jpg"
      ],
      "Religion": [
        false,
        "assets/images/Onboarding/Interests/causes-passionate-about/religion.jpg"
      ],
      "Racism": [
        false,
        "assets/images/Onboarding/Interests/causes-passionate-about/racism.jpg"
      ],
      "Obesity": [
        false,
        "assets/images/Onboarding/Interests/causes-passionate-about/obesity.jpg"
      ],
      "Animal Rights": [
        false,
        "assets/images/Onboarding/Interests/causes-passionate-about/animal-rights.jpg"
      ],
      "Climate Change": [
        false,
        "assets/images/Onboarding/Interests/causes-passionate-about/climate-change.jpg"
      ],
      "Marxism": [
        false,
        "assets/images/Onboarding/Interests/causes-passionate-about/marxism.png"
      ],
      "Capitalism": [
        false,
        "assets/images/Onboarding/Interests/causes-passionate-about/capitalism.jpg"
      ],
      "Spirituality": [
        false,
        "assets/images/Onboarding/Interests/causes-passionate-about/spirituality.jpg"
      ],
      "Education": [
        false,
        "assets/images/Onboarding/Interests/causes-passionate-about/education.jpg"
      ],
      "Health": [
        false,
        "assets/images/Onboarding/Interests/causes-passionate-about/health.jpg"
      ],
      "Sustainability": [
        false,
        "assets/images/Onboarding/Interests/causes-passionate-about/sustainability.jpg"
      ],
      "Addiction": [
        false,
        "assets/images/Onboarding/Interests/causes-passionate-about/addiction.jpg"
      ],
    },
    "Fandoms": {
      "Harry Potter": [
        false,
        "assets/images/Onboarding/Interests/fandoms/harry-potter.jpg"
      ],
      "Game of Thrones": [
        false,
        "assets/images/Onboarding/Interests/fandoms/game-of-thrones.jpg"
      ],
      "Twilight": [
        false,
        "assets/images/Onboarding/Interests/fandoms/twilight.png"
      ],
      "Marvel": [
        false,
        "assets/images/Onboarding/Interests/fandoms/marvel.jpg"
      ],
      "DC": [false, "assets/images/Onboarding/Interests/fandoms/dc.jpg"],
      "Avengers": [
        false,
        "assets/images/Onboarding/Interests/fandoms/avengers.jfif"
      ],
      "Justice League": [
        false,
        "assets/images/Onboarding/Interests/fandoms/justice-league.jpg"
      ],
      "Anime": [false, "assets/images/Onboarding/Interests/fandoms/anime.jpg"],
      "Star Wars": [
        false,
        "assets/images/Onboarding/Interests/fandoms/star-wars.jpg"
      ],
      "One Direction": [
        false,
        "assets/images/Onboarding/Interests/fandoms/one-direction.png"
      ],
      "Justin Bieber": [
        false,
        "assets/images/Onboarding/Interests/fandoms/justin-bieber.jpg"
      ],
      "Taylor Swift": [
        false,
        "assets/images/Onboarding/Interests/fandoms/taylor-swift.jpg"
      ],
      "Michael Jackson": [
        false,
        "assets/images/Onboarding/Interests/fandoms/michael-jackson.jpg"
      ],
      "Breaking Bad": [
        false,
        "assets/images/Onboarding/Interests/fandoms/breaking-bad.jpg"
      ],
      "Friends": [
        false,
        "assets/images/Onboarding/Interests/fandoms/friends.jpeg"
      ],
      "How I Met Your Mother": [
        false,
        "assets/images/Onboarding/Interests/fandoms/how-i-met-your-mother.jpg"
      ],
      "The Office": [
        false,
        "assets/images/Onboarding/Interests/fandoms/the-office.jpg"
      ],
      "Big Bang Theory": [
        false,
        "assets/images/Onboarding/Interests/fandoms/the-big-bang-theory.jpg"
      ],
      "Star Trek": [
        false,
        "assets/images/Onboarding/Interests/fandoms/star-trek.jpg"
      ],
      "Virat Kohli": [
        false,
        "assets/images/Onboarding/Interests/fandoms/virat-kohli.jpg"
      ],
      "Ranbir Kapoor": [
        false,
        "assets/images/Onboarding/Interests/fandoms/ranbir-kapoor.jpg"
      ],
      "BTS": [false, "assets/images/Onboarding/Interests/fandoms/bts.jpeg"],
      "Doctor Who": [
        false,
        "assets/images/Onboarding/Interests/fandoms/doctor-who.jpg"
      ],
      "Lord of the Rings": [
        false,
        "assets/images/Onboarding/Interests/fandoms/lord-of-the-rings.jpg"
      ],
      "Sherlock": [
        false,
        "assets/images/Onboarding/Interests/fandoms/sherlock.jpg"
      ],
      "Percy Jackson": [
        false,
        "assets/images/Onboarding/Interests/fandoms/percy-jackson.jpg"
      ],
      "Pokemon": [
        false,
        "assets/images/Onboarding/Interests/fandoms/pokemon.jpg"
      ],
      "Hunger Games": [
        false,
        "assets/images/Onboarding/Interests/fandoms/hunger-games.png"
      ],
      "Minecraft": [
        false,
        "assets/images/Onboarding/Interests/fandoms/minecraft.jpg"
      ],
      "Vampire Diaries": [
        false,
        "assets/images/Onboarding/Interests/fandoms/vampire-diaries.jfif"
      ],
      "Divergent": [
        false,
        "assets/images/Onboarding/Interests/fandoms/divergent.jpg"
      ],
      "Blackpink": [
        false,
        "assets/images/Onboarding/Interests/fandoms/blackpink.jpg"
      ],
      "Manchester United": [
        false,
        "assets/images/Onboarding/Interests/fandoms/manchester-united.jfif"
      ],
      "Barcelona": [
        false,
        "assets/images/Onboarding/Interests/fandoms/barcelona.jpg"
      ],
      "Real Madrid": [
        false,
        "assets/images/Onboarding/Interests/fandoms/real-madrid.jfif"
      ],
      "Liverpool": [
        false,
        "assets/images/Onboarding/Interests/fandoms/liverpool.jpg"
      ],
      "Arsenal": [
        false,
        "assets/images/Onboarding/Interests/fandoms/arsenal.jpg"
      ],
      "Chelsea": [
        false,
        "assets/images/Onboarding/Interests/fandoms/chelsea.jpg"
      ],
      "Mumbai Indians": [
        false,
        "assets/images/Onboarding/Interests/fandoms/mumbai-indians.jpg"
      ],
      "WWE": [false, "assets/images/Onboarding/Interests/fandoms/wwe.jpg"],
      "Formula 1": [
        false,
        "assets/images/Onboarding/Interests/fandoms/formula-1.jpg"
      ],
      "NBA": [false, "assets/images/Onboarding/Interests/fandoms/nba.jpg"],
      "Royal Challengers Bangalore": [
        false,
        "assets/images/Onboarding/Interests/fandoms/royal-challengers-banglore.jpg"
      ],
      "Chennai Super Kings": [
        false,
        "assets/images/Onboarding/Interests/fandoms/chennai-super-king.jpg"
      ],
      "Kolkata Knight Riders": [
        false,
        "assets/images/Onboarding/Interests/fandoms/kolkata-knight-riders.jpeg"
      ],
      "Manchester City": [
        false,
        "assets/images/Onboarding/Interests/fandoms/manchester-city.jpg"
      ],
      "LA Lakers": [
        false,
        "assets/images/Onboarding/Interests/fandoms/la-lakers.jpg"
      ],
      "Bayern Munich": [
        false,
        "assets/images/Onboarding/Interests/fandoms/bayern-munich.jpg"
      ],
      "Agatha Christie": [
        false,
        "assets/images/Onboarding/Interests/fandoms/agatha-christie.jpeg"
      ],
      "Dan Brown": [
        false,
        "assets/images/Onboarding/Interests/fandoms/dan-brown.jpg"
      ],
      "Nancy Drew": [
        false,
        "assets/images/Onboarding/Interests/fandoms/nancy-drew.jpg"
      ],
      "Fifty Shades": [
        false,
        "assets/images/Onboarding/Interests/fandoms/fifty-shades.jpg"
      ],
      "James Bond": [
        false,
        "assets/images/Onboarding/Interests/fandoms/james-bond.jpg"
      ],
      "Seinfeld": [
        false,
        "assets/images/Onboarding/Interests/fandoms/seinfeld.jpg"
      ],
    },
    "Competitive Exams": {
      "CAT": [
        false,
        "assets/images/Onboarding/Interests/competitve-exams/cat.jpg"
      ],
      "GMAT": [
        false,
        "assets/images/Onboarding/Interests/competitve-exams/gmat.jpg"
      ],
      "SAT": [
        false,
        "assets/images/Onboarding/Interests/competitve-exams/sat.jpg"
      ],
      "UPSC": [
        false,
        "assets/images/Onboarding/Interests/competitve-exams/upsc.jpg"
      ],
      "TOEFL": [
        false,
        "assets/images/Onboarding/Interests/competitve-exams/toefl.jpg"
      ],
      "GRE": [
        false,
        "assets/images/Onboarding/Interests/competitve-exams/gre.jpg"
      ],
      "JEE": [
        false,
        "assets/images/Onboarding/Interests/competitve-exams/jee.jpg"
      ],
      "AIIMS": [
        false,
        "assets/images/Onboarding/Interests/competitve-exams/aiims.png"
      ],
      "BITSAT": [
        false,
        "assets/images/Onboarding/Interests/competitve-exams/bitsat.jpg"
      ],
      "NEET": [
        false,
        "assets/images/Onboarding/Interests/competitve-exams/neet.jpg"
      ],
      "IELTS": [
        false,
        "assets/images/Onboarding/Interests/competitve-exams/ielts.jpg"
      ],
      "GATE": [
        false,
        "assets/images/Onboarding/Interests/competitve-exams/gate.jpeg"
      ],
      "CLAT": [
        false,
        "assets/images/Onboarding/Interests/competitve-exams/clat.jpg"
      ],
    },
    "Miscellaneous": {
      "Fashion and makeup": [
        false,
        "assets/images/Onboarding/Interests/miscellaneous/fashion-and-makeup.jpg"
      ],
      "Gardening": [
        false,
        "assets/images/Onboarding/Interests/miscellaneous/gardening.jpg"
      ],
      "Playmates for young children": [
        false,
        "assets/images/Onboarding/Interests/miscellaneous/playmates.jpg"
      ],
      "Charity": [
        false,
        "assets/images/Onboarding/Interests/miscellaneous/charity.jpg"
      ],
      "Home Décor": [
        false,
        "assets/images/Onboarding/Interests/miscellaneous/home-decor.jpg"
      ],
      "Pets": [
        false,
        "assets/images/Onboarding/Interests/miscellaneous/pets.jpg"
      ],
      "Cars and Bikes": [
        false,
        "assets/images/Onboarding/Interests/miscellaneous/cars.jpg"
      ],
      "Technology": [
        false,
        "assets/images/Onboarding/Interests/miscellaneous/technology.jpg"
      ],
    }
  };

  Map get getCategories => _categoriesMap;

  Map get getSubCategories => _subCategoriesMap;

  String _selectedCategory = "Outdoor Sports";
  String get getSelectedCategory => _selectedCategory;
  set setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  bool _interestsLoading = false;
  bool get isInterestsLoading => _interestsLoading;
  set isInterestsLoading(bool val) => _interestsLoading = val;

  void selectedCategory(String category) {
    _selectedCategory = category;
    _categoriesMap[category] = true;
    _subCategoriesMap.forEach((category, subCategory) {
      int count = 0;
      (subCategory as Map<String, dynamic>).forEach((key, value) {
        if (value[0] == true) {
          count += 1;
        }
      });
      if (count == 0 && _selectedCategory != category) {
        _categoriesMap[category] = false;
      }
    });
    notifyListeners();
  }

  Future<void> deSelectedCategory(
      String category, ItemScrollController _controller) async {
    _selectedCategory = category;
    _categoriesMap[category] = false;
    (_subCategoriesMap[category] as Map).values.forEach((element) {
      if (element[0] == true) {
        element[0] = false;
      }
    });
    for (var key in _categoriesMap.keys) {
      if (_categoriesMap[key] == true) {
        _selectedCategory = key;
        break;
      }
    }
    _controller.scrollTo(
        index: _categoriesMap.keys.toList().indexOf(_selectedCategory),
        duration: Duration(milliseconds: 500));
    notifyListeners();
  }

  void selectSubCategory(String subCategory) {
    if (_subCategoriesMap[_selectedCategory][subCategory][0] == false) {
      _subCategoriesMap[_selectedCategory][subCategory][0] = true;
    } else {
      _subCategoriesMap[_selectedCategory][subCategory][0] = false;
    }
    notifyListeners();
  }

  Future<void> checkMinimumInterestsSelected(
      BuildContext context, String source) async {
    List<String> selectedInterests = [];
    _subCategoriesMap.values.forEach((interest) {
      (interest as Map).values.forEach((isSelected) {
        if (isSelected[0] == true) {
          List<String> keys = (interest as Map<String, dynamic>).keys.toList();
          keys.forEach((element) {
            if (interest[element] == isSelected) selectedInterests.add(element);
          });
        }
      });
    });

    if (source == "filter") {
      _subCategoriesMap.values.forEach((interest) {
        (interest as Map).values.forEach((isSelected) {
          if (isSelected[0] == true) isSelected[0] = false;
        });
      });

      _categoriesMap.forEach((key, value) {
        print(value);
      });

      notifyListeners();
      Navigator.pop(context, selectedInterests);
    } else {
      if (selectedInterests.length < 5) {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.07,
              child: Center(
                child: Text(
                  "Please select minimum 5 sub-interests to proceed!",
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                      fontSize: MediaQuery.of(context).size.height * 0.018),
                ),
              ),
            );
          },
        );
      } else {
        sharedPrefs.myInterests = json.encode(
          selectedInterests.map<String>((interest) => interest).toList(),
        );
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection("users")
            .doc(sharedPrefs.userid)
            .get();

        if (doc.exists) {
          final List fetchedList = doc["interestList"] as List;

          isInterestsLoading = true;
          FirebaseFirestore.instance
              .collection("users")
              .doc(sharedPrefs.userid)
              .update({
            "interestList": FieldValue.arrayRemove(fetchedList)
          }).then((_) {
            FirebaseFirestore.instance
                .collection("users")
                .doc(sharedPrefs.userid)
                .update(
                    {"interestList": FieldValue.arrayUnion(selectedInterests)});
            isInterestsLoading = false;
          });
        }

        if (source == null) {
          Navigator.pushNamed(context, rOnboardingUser,
              arguments: selectedInterests);
        } else {
          Navigator.of(context).pop();
        }
      }
    }
  }

  Future<bool> fetchInterests() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPrefs.userid)
        .get();
    if (doc.exists) {
      final List fetchedList = doc["interestList"] as List;
      if (fetchedList != null && fetchedList.isNotEmpty) {
        _subCategoriesMap.values.forEach((subCategory) {
          (subCategory as Map).keys.forEach((element) {
            if (fetchedList.contains(element)) {
              subCategory[element][0] = true;
            }
          });
        });
        fetchedList.forEach((element) {
          _subCategoriesMap.forEach((key, value) {
            if ((value as Map).containsKey(element)) {
              _categoriesMap[key] = true;
            }
          });
        });
        notifyListeners();
      }
    }
    return true;
  }

  Future<bool> selectInterestListFromFilters(List<String> interestList) async {
    final List fetchedList = interestList;
    if (fetchedList != null && fetchedList.isNotEmpty) {
      _subCategoriesMap.values.forEach((subCategory) {
        (subCategory as Map).keys.forEach((element) {
          if (fetchedList.contains(element)) {
            subCategory[element][0] = true;
          }
        });
      });
      fetchedList.forEach((element) {
        _subCategoriesMap.forEach((key, value) {
          if ((value as Map).containsKey(element)) {
            _categoriesMap[key] = true;
          }
        });
      });
      notifyListeners();
    }
    return true;
  }
}
