# Set ulimits max open files
#
define riak::tuning::limits (
    String[1] $user, String[1] $type, String[1] $item, Integer $value
  ) {

  $key = "$user/$type/$item"
  $path_list  = "domain[.=\"$user\"][./type=\"$type\" and ./item=\"$item\"]"
  $path_match = "domain[.=\"$user\"][./type=\"$type\" and ./item=\"$item\" and ./value=\"$value\"]"

  augeas { "limits_conf/$key":
    context => $::riak::ulimits_context,
    onlyif  => "match $path_match size != 1",
    changes => [
      "rm $path_list",
      "set domain[last()+1] $user",
      "set domain[last()]/type $type",
      "set domain[last()]/item $item",
      "set domain[last()]/value $value",
      ],
  }
}
