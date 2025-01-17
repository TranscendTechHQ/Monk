/* generated using openapi-typescript-codegen -- do not edit */
/* istanbul ignore file */
/* tslint:disable */
/* eslint-disable */
import type { BlockModel } from './BlockModel';
export type ThreadModel = {
    _id?: string;
    assigned_to_id?: (string | null);
    content?: Array<BlockModel>;
    created_at?: string;
    creator_id: string;
    headline?: string;
    last_modified: string;
    num_blocks?: number;
    parent_block_id?: (string | null);
    slack_thread_ts?: (number | null);
    tenant_id: string;
    topic: string;
    type: string;
};

