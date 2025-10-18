# Packet Manager.gd
func steam_id_to_socket_number(steam_id : int):
  for i in instance_handler.instance_property_array:
    if i.user_id == steam_id:
      return i.socket_number
  return -1

func read_p2p_packet():
  # ...
  if readable_data.has("sent_from_socket"): 
    readable_data["sent_from_socket"] = steam_id_to_socket_number(packet_sender)

# Packet Verification.gd

func PacketSort(dict : Dictionary):
  var dict_id = dict.get("id", 0)
  match dict_id:
    # Replace all other cases with ids
    22:
      packet = {
        "packet category": "MP_UserInstanceProperties",
        "packet alias": "interact with item",
        "sent_from": "host",
        "packet_id": 23,
        "item_socket_number": dict.item_socket_number,
        "local_grid_index": dict.local_grid_index,
        "item_id": dict.item_id,
        "socket_number": dict.sent_from_socket,
        "stealing_item": dict.stealing_item,
        "ending_turn_after_item_use": game_state.CheckIfEndingTurnAfterItemUse(dict.item_id, dict.sent_from_socket),
        "current_shell_in_chamber": "",
        "phone_verbal_shell": "",
        "phone_verbal_index": "",
      }
      if dict.item_id == 2: # Magnifier
        custom_target_packet = packet.duplicate(true)
        custom_target_packet.current_shell_in_chamber = game_state.MAIN_active_sequence_dict.sequence_in_shotgun[0]
        custom_target_id = game_state.GetSocketID(dict.sent_from_socket)
      else if dict.item_id == 5: # Beer
        packet.current_shell_in_chamber = game_state.MAIN_active_sequence_dict.sequence_in_shotgun[0]
