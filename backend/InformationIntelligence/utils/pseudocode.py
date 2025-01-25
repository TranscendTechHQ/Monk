
get_topics_messages_from_mongo = ...
split_topic_messages_into_batches = ...
format_topics_batches_into_chats = ...
process_batches_and_get_llm_outputs = ...
parse_jsons_from_llm_outputs = ...
input_batches = ...
corresponding_llm_outputs = ...
parse_json_from_llm_output = ...
matching_topics_from_input_to_the_output = ...
add_input_batch_to_remaining_batches = ...
everything = ...
update_final_answer_json_with_successful_relevance = ...

























get_topics_messages_from_mongo()
split_topic_messages_into_batches()
input_remaining_batches = format_topics_batches_into_chats()

final_answer_json = {}

while input_remaining_batches:
    llm_outputs = process_batches_and_get_llm_outputs()
    final_answer_json, input_remaining_batches = parse_jsons_from_llm_outputs()


===============================================================================================


def parse_jsons_from_llm_outputs():
    for input_batch, corresponding_llm_output in (input_batches, corresponding_llm_outputs):
        try:
            parse_json_from_llm_output()
        try :
            matching_topics_from_input_to_the_output()
        
        
        if everything above runs smoothly:
            update_final_answer_json_with_successful_relevance()
        else:
            add_input_batch_to_remaining_batches()