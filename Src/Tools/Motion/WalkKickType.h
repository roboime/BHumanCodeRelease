/**
 * @file WalkKickType.h
 *
 * This file declares the walk kick types.
 *
 * @author Philip Reichenberg
 */

#pragma once
#include "Streaming/Enum.h"

namespace WalkKicks
{
  ENUM(Type,
  {,
    none,
    forward,
    forwardLong,
    forwardVeryLong,
    sidewardsOuter,
    turnOut,
    forwardSteal,
    forwardAlternative,
  });
}
