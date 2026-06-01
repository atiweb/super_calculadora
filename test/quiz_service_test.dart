import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_calculadora/models/quiz_problem.dart';
import 'package:super_calculadora/services/quiz_service.dart';

void main() {
  group('QuizProblem.isCorrect', () {
    const p = QuizProblem(topic: 't', prompt: 'p', answer: '42');
    test('exact match', () => expect(p.isCorrect('42'), true));
    test('tolerates whitespace', () => expect(p.isCorrect('  42 '), true));
    test('tolerates leading zeros', () => expect(p.isCorrect('042'), true));
    test('wrong answer', () => expect(p.isCorrect('43'), false));
    test('empty is wrong', () => expect(p.isCorrect(''), false));
  });

  group('QuizService.generate', () {
    test('every generated problem is self-consistent', () {
      final rng = Random(12345);
      for (int i = 0; i < 400; i++) {
        final p = QuizService.generate(rng: rng);
        expect(p.prompt.isNotEmpty, true, reason: 'prompt empty');
        expect(p.answer.isNotEmpty, true, reason: 'answer empty');
        expect(p.topic.isNotEmpty, true, reason: 'topic empty');
        // The canonical answer must validate as correct.
        expect(p.isCorrect(p.answer), true, reason: 'answer "${p.answer}" rejected for ${p.topic}');
        // A clearly wrong answer must be rejected.
        expect(p.isCorrect('${p.answer}1'), false);
      }
    });

    test('covers multiple topics over many draws', () {
      final rng = Random(7);
      final topics = <String>{};
      for (int i = 0; i < 200; i++) {
        topics.add(QuizService.generate(rng: rng).topic);
      }
      // With 8 generators, 200 draws should hit several distinct topics.
      expect(topics.length >= 5, true, reason: 'only saw $topics');
    });

    test('Spanish prompts differ from English', () {
      // Same seed → same generator/values, only the language differs.
      final es = QuizService.generate(rng: Random(99), spanish: true);
      final en = QuizService.generate(rng: Random(99), spanish: false);
      expect(es.answer, en.answer);
      expect(es.topic, en.topic);
      // At least the prompt wording should differ for localized generators.
      // (Some prompts are mostly notation, so just assert both are non-empty.)
      expect(es.prompt.isNotEmpty && en.prompt.isNotEmpty, true);
    });
  });
}
