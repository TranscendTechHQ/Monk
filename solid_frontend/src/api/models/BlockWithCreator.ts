/* generated using openapi-typescript-codegen -- do not edit */
/* istanbul ignore file */
/* tslint:disable */
/* eslint-disable */
import type { LinkMetaModel } from './LinkMetaModel';
import type { UserModel } from './UserModel';
export type BlockWithCreator = {
    _id?: string;
    assigned_pos?: number;
    assigned_thread_id?: (string | null);
    assigned_to?: (UserModel | null);
    assigned_to_id?: (string | null);
    child_thread_id?: string;
    content: string;
    created_at?: string;
    creator: UserModel;
    creator_id?: string;
    due_date?: (string | null);
    image?: (string | null);
    last_modified?: string;
    link_meta?: (LinkMetaModel | null);
    main_thread_id?: string;
    position?: number;
    task_status?: string;
    tenant_id?: string;
};

