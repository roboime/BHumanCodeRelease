#pragma once

#include "Tools/Motion/SensorData.h"
#include "Math/Angle.h"
#include "RobotParts/Joints.h"
#include "Streaming/EnumIndexedArray.h"
#include "Platform/BHAssert.h"

STREAMABLE(JointAngles,
{
public:
  static constexpr Angle off = SensorData::off; /**< Special value that indicates that the joint is turned off. */
  static constexpr Angle ignore = SensorData::ignore; /**< Special angle for not overwriting the previous setting. */

  JointAngles();

  void draw();

  /**
   * The method returns the angle of the mirror (left/right) of the given joint.
   * @param joint The joint the mirror of which is returned.
   * @return The angle of the mirrored joint.
   */
  Angle mirror(Joints::Joint joint) const;

  /** Initializes this instance with the mirrored angles of other. */
  void mirror(const JointAngles& other);

private:
  /**
   * Negate joint angle if it is a legal one.
   * @param angle The angle to negate. Can also be "off" or "ignore".
   * @return The mirrored joint angle.
   */
  static float mirror(float angle);

public:
  ,
  (ENUM_INDEXED_ARRAY(Angle, Joints::Joint)) angles, /**< The angles of all joints. */
  (ENUM_INDEXED_ARRAY(Angle, Joints::Joint)) variance, /**< The variance of all joints in squared rad. */
  (unsigned)(0) timestamp, /**< The time when the jointangles were received*/
});

inline JointAngles::JointAngles()
{
  angles.fill(0.f);
  variance.fill(0.f);
}

inline void JointAngles::mirror(const JointAngles& other)
{
  ASSERT(this != &other);
  for(int i = 0; i < Joints::numOfJoints; ++i)
    angles[i] = other.mirror(static_cast<Joints::Joint>(i));
  timestamp = other.timestamp;
}

inline float JointAngles::mirror(float angle)
{
  return (angle == off || angle == ignore) ? angle : -angle;
}
