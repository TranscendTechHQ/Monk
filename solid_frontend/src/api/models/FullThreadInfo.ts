/* generated using openapi-typescript-codegen -- do not edit */
/* istanbul ignore file */
/* tslint:disable */
/* eslint-disable */
import type { BlockModel } from './BlockModel';
import type { BlockWithCreator } from './BlockWithCreator';
import type { UserModel } from './UserModel';
export type FullThreadInfo = {
    _id: string;
    assigned?: (boolean | null);
    assigned_to_id?: (string | null);
    block?: (BlockModel | null);
    bookmark?: (boolean | null);
    content?: Array<BlockWithCreator>;
    created_at: string;
    creator: UserModel;
    default_block?: BlockWithCreator;
    headline?: string;
    last_modified?: string;
    mention?: (boolean | null);
    num_blocks?: number;
    parent_block_id?: (string | null);
    topic: string;
    type: string;
    unfollow?: (boolean | null);
    unread?: (boolean | null);
    upvote?: (boolean | null);
};

