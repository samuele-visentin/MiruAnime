// GENERATED CODE - DO NOT MODIFY BY HAND
// This code was generated by ObjectBox. To update it run the generator again:
// With a Flutter package, run `flutter pub run build_runner build`.
// With a Dart package, run `dart run build_runner build`.
// See also https://docs.objectbox.io/getting-started#generate-objectbox-code

// ignore_for_file: camel_case_types

import 'dart:typed_data';

// ignore: depend_on_referenced_packages
import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart';
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import 'backend/database/anime_saved.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(1, 4435384651597019710),
      name: 'AnimeDatabase',
      lastPropertyId: const IdUid(9, 2211110247357550496),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 6642653038717941767),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 1624324498582935196),
            name: 'animeID',
            type: 9,
            flags: 2048,
            indexId: const IdUid(1, 1782501352687934008)),
        ModelProperty(
            id: const IdUid(3, 3724183071520773738),
            name: 'title',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 2778369010634874414),
            name: 'imgUrl',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 7173841413930794411),
            name: 'animeUrl',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 8677672389133642407),
            name: 'currentEpisode',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 7784180153386615748),
            name: 'time',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 1910135139490616878),
            name: 'userFinishedToWatch',
            type: 1,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 2211110247357550496),
            name: 'animeIsFinished',
            type: 1,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[])
];

/// Open an ObjectBox store with the model declared in this file.
Future<Store> openStore(
        {String? directory,
        int? maxDBSizeInKB,
        int? fileMode,
        int? maxReaders,
        bool queriesCaseSensitiveDefault = true,
        String? macosApplicationGroup}) async =>
    Store(getObjectBoxModel(),
        directory: directory ?? (await defaultStoreDirectory()).path,
        maxDBSizeInKB: maxDBSizeInKB,
        fileMode: fileMode,
        maxReaders: maxReaders,
        queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
        macosApplicationGroup: macosApplicationGroup);

/// ObjectBox model definition, pass it to [Store] - Store(getObjectBoxModel())
ModelDefinition getObjectBoxModel() {
  final model = ModelInfo(
      entities: _entities,
      lastEntityId: const IdUid(1, 4435384651597019710),
      lastIndexId: const IdUid(1, 1782501352687934008),
      lastRelationId: const IdUid(0, 0),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [],
      retiredIndexUids: const [],
      retiredPropertyUids: const [],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, EntityDefinition>{
    AnimeDatabase: EntityDefinition<AnimeDatabase>(
        model: _entities[0],
        toOneRelations: (AnimeDatabase object) => [],
        toManyRelations: (AnimeDatabase object) => {},
        getId: (AnimeDatabase object) => object.id,
        setId: (AnimeDatabase object, int id) {
          object.id = id;
        },
        objectToFB: (AnimeDatabase object, fb.Builder fbb) {
          final animeIDOffset = fbb.writeString(object.animeID);
          final titleOffset = fbb.writeString(object.title);
          final imgUrlOffset = fbb.writeString(object.imgUrl);
          final animeUrlOffset = fbb.writeString(object.animeUrl);
          final currentEpisodeOffset = fbb.writeString(object.currentEpisode);
          final timeOffset = fbb.writeString(object.time);
          fbb.startTable(10);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, animeIDOffset);
          fbb.addOffset(2, titleOffset);
          fbb.addOffset(3, imgUrlOffset);
          fbb.addOffset(4, animeUrlOffset);
          fbb.addOffset(5, currentEpisodeOffset);
          fbb.addOffset(6, timeOffset);
          fbb.addBool(7, object.userFinishedToWatch);
          fbb.addBool(8, object.animeIsFinished);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = AnimeDatabase(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              animeID: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 6, ''),
              title: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 8, ''),
              imgUrl: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 10, ''),
              animeUrl: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 12, ''),
              currentEpisode: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 14, ''),
              time: const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 16, ''),
              animeIsFinished: const fb.BoolReader()
                  .vTableGet(buffer, rootOffset, 20, false),
              userFinishedToWatch: const fb.BoolReader()
                  .vTableGet(buffer, rootOffset, 18, false));

          return object;
        })
  };

  return ModelDefinition(model, bindings);
}

/// [AnimeDatabase] entity fields to define ObjectBox queries.
class AnimeDatabase_ {
  /// see [AnimeDatabase.id]
  static final id =
      QueryIntegerProperty<AnimeDatabase>(_entities[0].properties[0]);

  /// see [AnimeDatabase.animeID]
  static final animeID =
      QueryStringProperty<AnimeDatabase>(_entities[0].properties[1]);

  /// see [AnimeDatabase.title]
  static final title =
      QueryStringProperty<AnimeDatabase>(_entities[0].properties[2]);

  /// see [AnimeDatabase.imgUrl]
  static final imgUrl =
      QueryStringProperty<AnimeDatabase>(_entities[0].properties[3]);

  /// see [AnimeDatabase.animeUrl]
  static final animeUrl =
      QueryStringProperty<AnimeDatabase>(_entities[0].properties[4]);

  /// see [AnimeDatabase.currentEpisode]
  static final currentEpisode =
      QueryStringProperty<AnimeDatabase>(_entities[0].properties[5]);

  /// see [AnimeDatabase.time]
  static final time =
      QueryStringProperty<AnimeDatabase>(_entities[0].properties[6]);

  /// see [AnimeDatabase.userFinishedToWatch]
  static final userFinishedToWatch =
      QueryBooleanProperty<AnimeDatabase>(_entities[0].properties[7]);

  /// see [AnimeDatabase.animeIsFinished]
  static final animeIsFinished =
      QueryBooleanProperty<AnimeDatabase>(_entities[0].properties[8]);
}
