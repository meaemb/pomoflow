import 'tip_step.dart';
import 'tip_model.dart';

class Tip {
  final String id;
  final String name;
  final String description;
  final String provider;
  final double rating;
  final String duration;
  final String level;
  final String imageUrl;
  final List<TipStep> steps;

  Tip({
    required this.id,
    required this.name,
    required this.description,
    required this.provider,
    required this.rating,
    required this.duration,
    required this.level,
    required this.imageUrl,
    required this.steps,
  });

  // Конвертация из TipModel в Tip
  factory Tip.fromModel(TipModel model) {
    return Tip(
      id: model.id,
      name: model.name,
      description: model.description,
      provider: model.provider,
      rating: model.rating,
      duration: model.duration,
      level: model.level,
      imageUrl: model.imageUrl,
      steps: model.steps.map((stepModel) => TipStep(
        title: stepModel.title,
        description: stepModel.description,
        fullDescription: stepModel.fullDescription,
        duration: stepModel.duration,
        tip: stepModel.tip,
        durationInMinutes: stepModel.durationInMinutes,
      )).toList(),
    );
  }

  String getRatingAndDuration() {
    return '⭐ $rating • $duration • $level';
  }

  // Запасные данные (используются, если JSON не загрузился)
  static List<Tip> samples = [
    Tip(
      id: 'pomodoro',
      name: 'Pomodoro Technique',
      description: 'Work 25 min, break 5 min. Repeat 4 times, then long break.',
      provider: 'PomoFlow',
      rating: 4.9,
      duration: '25 min',
      level: 'Beginner',
      imageUrl: 'assets/tips/pomodoro.jpg',
      steps: [
        TipStep(
          title: 'Choose a task',
          description: 'Pick one specific task',
          fullDescription: 'Select one specific task you want to accomplish.',
          duration: '1-2 min',
          tip: 'Start with the most important task.',
          durationInMinutes: 25,
        ),
        TipStep(
          title: 'Set timer 25 min',
          description: 'Focus only on that task',
          fullDescription: 'Start the timer for 25 minutes.',
          duration: '25 min',
          tip: 'Put your phone away.',
          durationInMinutes: 25,
        ),
        TipStep(
          title: 'Take 5 min break',
          description: 'Step away from desk',
          fullDescription: 'Step away from your desk.',
          duration: '5 min',
          tip: 'Walk around, stretch.',
          durationInMinutes: 5,
        ),
        TipStep(
          title: 'Repeat 4 times',
          description: 'Then take 15-30 min break',
          fullDescription: 'After 4 Pomodoros, take a longer break.',
          duration: 'After 4 cycles',
          tip: 'You deserve a longer break!',
          durationInMinutes: 15,
        ),
      ],
    ),
    Tip(
      id: 'no_phone',
      name: 'No Phone Rule',
      description: 'Keep phone away during work sessions',
      provider: 'PomoFlow',
      rating: 4.7,
      duration: '25 min',
      level: 'Easy',
      imageUrl: 'assets/tips/nophone.jpg',
      steps: [
        TipStep(
          title: 'Put phone away',
          description: 'Keep in another room',
          fullDescription: 'Physically place your phone in another room.',
          duration: '1 min',
          tip: 'Use an alarm clock instead.',
          durationInMinutes: 25,
        ),
        TipStep(
          title: 'Use Focus Mode',
          description: 'Enable Do Not Disturb',
          fullDescription: 'Enable Do Not Disturb mode on all your devices.',
          duration: '1 min',
          tip: 'Most phones have Focus Mode.',
          durationInMinutes: 25,
        ),
        TipStep(
          title: 'Check on breaks',
          description: 'Only during breaks',
          fullDescription: 'Only check your phone during scheduled breaks.',
          duration: '5 min',
          tip: 'Set a timer for phone check.',
          durationInMinutes: 5,
        ),
      ],
    ),
    Tip(
      id: 'one_task',
      name: 'One Task at a Time',
      description: 'Focus on one thing',
      provider: 'PomoFlow',
      rating: 4.8,
      duration: '25 min',
      level: 'Intermediate',
      imageUrl: 'assets/tips/onetask.jpg',
      steps: [
        TipStep(
          title: 'Write down your task',
          description: 'Be specific',
          fullDescription: 'Write down exactly what you need to accomplish.',
          duration: '2 min',
          tip: 'Use a notebook.',
          durationInMinutes: 25,
        ),
        TipStep(
          title: 'Block distractions',
          description: 'Close unnecessary tabs',
          fullDescription: 'Close all unnecessary browser tabs.',
          duration: '2 min',
          tip: 'Use website blockers.',
          durationInMinutes: 25,
        ),
        TipStep(
          title: 'Work until timer rings',
          description: 'No switching',
          fullDescription: 'Do not switch tasks until the timer rings.',
          duration: '25 min',
          tip: 'Write down new tasks for later.',
          durationInMinutes: 25,
        ),
      ],
    ),
    Tip(
      id: 'take_breaks',
      name: 'Take Breaks Seriously',
      description: 'Breaks help you recharge',
      provider: 'PomoFlow',
      rating: 4.6,
      duration: '5 min',
      level: 'Easy',
      imageUrl: 'assets/tips/breaks.jpg',
      steps: [
        TipStep(
          title: 'Stand up and stretch',
          description: 'Move your body',
          fullDescription: 'Stand up from your desk and stretch.',
          duration: '2 min',
          tip: 'Set a timer to stand up every hour.',
          durationInMinutes: 5,
        ),
        TipStep(
          title: 'Drink water',
          description: 'Stay hydrated',
          fullDescription: 'Drink a glass of water.',
          duration: '1 min',
          tip: 'Aim for 8 glasses per day.',
          durationInMinutes: 5,
        ),
        TipStep(
          title: 'Deep breaths',
          description: 'Reset your mind',
          fullDescription: 'Take 5 deep breaths.',
          duration: '2 min',
          tip: 'Try the 4-7-8 breathing technique.',
          durationInMinutes: 5,
        ),
      ],
    ),
  ];
}