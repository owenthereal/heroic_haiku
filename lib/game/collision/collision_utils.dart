import 'package:heroic_haiku/game/collision/collision_box.dart';
import 'package:heroic_haiku/game/obstacle/obstacle.dart';
import 'package:heroic_haiku/game/ninja/config.dart';
import 'package:heroic_haiku/game/ninja/ninja.dart';

bool checkForCollision(Obstacle obstacle, Ninja ninja) {
  final ninjaBox = CollisionBox(
    x: ninja.x + 1,
    y: ninja.y + 1,
    width: NinjaConfig.width - 2,
    height: NinjaConfig.height - 2,
  );

  final obstacleBox = CollisionBox(
    x: obstacle.x + 1,
    y: obstacle.y + 1,
    width: obstacle.type.width * obstacle.internalSize - 2,
    height: obstacle.type.height - 2,
  );

  if (boxCompare(ninjaBox, obstacleBox)) {
    final collisionBoxes = obstacle.collisionBoxes;
    final ninjaCollisionBoxes = NinjaCollisionBoxes.running;

    bool crashed = false;

    for (final obstacleCollisionBox in collisionBoxes) {
      final adjObstacleBox = createAdjustedCollisionBox(
        obstacleCollisionBox,
        obstacleBox,
      );

      for (final ninjaCollisionBox in ninjaCollisionBoxes) {
        final adjNinjaBox = createAdjustedCollisionBox(
          ninjaCollisionBox,
          ninjaBox,
        );
        crashed = crashed || boxCompare(adjNinjaBox, adjObstacleBox);
      }
    }

    return crashed;
  }
  return false;
}

bool boxCompare(CollisionBox ninjaBox, CollisionBox obstacleBox) {
  final double obstacleX = obstacleBox.x;
  final double obstacleY = obstacleBox.y;

  return ninjaBox.x < obstacleX + obstacleBox.width &&
      ninjaBox.x + ninjaBox.width > obstacleX &&
      ninjaBox.y < obstacleBox.y + obstacleBox.height &&
      ninjaBox.height + ninjaBox.y > obstacleY;
}

CollisionBox createAdjustedCollisionBox(
    CollisionBox box, CollisionBox adjustment) {
  return CollisionBox(
    x: box.x + adjustment.x,
    y: box.y + adjustment.y,
    width: box.width,
    height: box.height,
  );
}
