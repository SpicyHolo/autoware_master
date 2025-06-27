### OPTIONAL
IGNORE_TF=false
IGNORE_ODOM=false

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --no_tf)
      IGNORE_TF=true
      ;;
    --no_odom)
      IGNORE_ODOM=true
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
  shift
done

echo "Ignore TF: $IGNORE_TF"
echo "Ignore Odom: $IGNORE_DOOM"

if [ "$IGNORE_TF" = true ]; then
  export MOLA_USE_FIXED_LIDAR_POSE=true
  export MOLA_USE_FIXED_IMU_POSE=true
  export MOLA_USE_FIXED_GPS_POSE=true
fi

# if [ "$IGNORE_ODOM" = true]; then
#
# fi

# Set topics
LIDAR_TOPIC=/seinsing/lidar/top/pointcloud
GNSS_TOPIC=/sensing/gnss/ublox_rover_node/fix
IMU_TOPIC=/sensing/imu/imu_data
ODOM_TOPIC=

# ENVs
export MOLA_LIDAR_TOPIC=${LIDAR_TOPIC}
export MOLA_GNSS_TOPIC=${GNSS_TOPIC}
export MOLA_IMU_TOPIC=${IMU_TOPIC}

# Map export
export MOLA_GENERATE_SIMPLEMAP=true
export MOLA_SIMPLEMAP_OUTPUT=map.simplemap

# Trajectory export
export MOLA_SAVE_TRAJECTORY=true
export MOLA_TUM_TRAJECTORY_OUTPUT=traj.tum


# Read ROSBAG2 through topics
ros2 launch mola_lidar_odometry ros2-lidar-odometry.launch.py \
    lidar_topic_name:=${LIDAR_TOPIC} \
    ignore_lidar_pose_from_tf:=${IGNORE_TF} \
    gnss_topic_name:=${GNSS_TOPIC} \
    imu_topic_name:=${IMU_TOPIC} \
    use_rviz:=false \
    publish_localization_following_rep105:=false \
    generate_simplemap:=true
