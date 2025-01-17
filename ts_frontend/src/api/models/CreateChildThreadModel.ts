/* generated using openapi-typescript-codegen -- do not edit */
/* istanbul ignore file */
/* tslint:disable */
/* eslint-disable */
import type { BlockModel } from './BlockModel';
export type CreateChildThreadModel = {
    assignedId?: (string | null);
    content?: Array<BlockModel>;
    mainThreadId: string;
    parentBlockId: string;
    topic: string;
    type: string;
};

