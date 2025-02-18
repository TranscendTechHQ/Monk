/* generated using openapi-typescript-codegen -- do not edit */
/* istanbul ignore file */
/* tslint:disable */
/* eslint-disable */
import type { LinkMetaModel } from './LinkMetaModel';
export type ThreadResponse = {
    _id?: string;
    created_at?: string;
    creator_id?: string;
    image?: (string | null);
    last_modified?: string;
    link_meta?: (LinkMetaModel | null);
    text?: string;
    topic: string;
};

