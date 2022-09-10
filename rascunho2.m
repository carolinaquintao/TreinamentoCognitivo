%% RT
% cellfun(@graph_analysis_mst,v_conn_data_graph_analysis_rt,v_conn_data_graph_analysis_rt_labels);
% cellfun(@graph_analysis_mst,v_conn_data_graph_analysis_rt(8),v_conn_data_graph_analysis_rt_labels(8));

%% Bench
cellfun(@graph_analysis_mst,v_conn_data_graph_analysis_bench,v_conn_data_graph_analysis_bench_label);
% cellfun(@graph_analysis_mst,v_conn_data_graph_analysis_bench(2),v_conn_data_graph_analysis_bench_label(2));

disp('Fim');
delete('./S11D/Connectivity_S11D/prompt.mat');
delete('./S11D/Connectivity_S11D/thrd.mat');

% rt_groups = {rt_e_sw_coef,rt_b_sw_coef,rt_r_sw_coef,rtPos_e_sw_coef,rtPos_b_sw_coef, rtPos_r_sw_coef}
% save('./S11D/Graph_analysis_NewGroups_Division_original_ch_order/rt_groups.mat','rt_groups');

%% RT

%swi
rt_swi_groups = c;
rtPos_swi_groups = [rtPos_swi_e , rtPos_swi_b , rtPos_swi_r];

%sw_coef
rt_sw_coef_groups = [rt_sw_coef_e , rt_sw_coef_b , rt_sw_coef_r];
rtPos_sw_coef_groups = [rtPos_sw_coef_e , rtPos_sw_coef_b , rtPos_sw_coef_r];

%sw_coefE
rt_sw_coefE_groups = [rt_sw_coefE_e , rt_sw_coefE_b , rt_sw_coefE_r];
rtPos_sw_coefE_groups = [rtPos_sw_coefE_e , rtPos_sw_coefE_b , rtPos_sw_coefE_r];

%sw_coefW
rt_sw_coefW_groups = [rt_sw_coefW_e , rt_sw_coefW_b , rt_sw_coefW_r];
rtPos_sw_coefW_groups = [rtPos_sw_coefW_e , rtPos_sw_coefW_b , rtPos_sw_coefW_r];

save('./S11D/Graph_analysis_NewGroups_Division_original_ch_order/rt_swi_groups.mat','rt_swi_groups');
save('./S11D/Graph_analysis_NewGroups_Division_original_ch_order/rtPos_swi_groups.mat','rtPos_swi_groups');
save('./S11D/Graph_analysis_NewGroups_Division_original_ch_order/rt_sw_coef_groups.mat','rt_sw_coef_groups');
save('./S11D/Graph_analysis_NewGroups_Division_original_ch_order/rtPos_sw_coef_groups.mat','rtPos_sw_coef_groups');
save('./S11D/Graph_analysis_NewGroups_Division_original_ch_order/rt_sw_coefE_groups.mat','rt_sw_coefE_groups');
save('./S11D/Graph_analysis_NewGroups_Division_original_ch_order/rtPos_sw_coefE_groups.mat','rtPos_sw_coefE_groups');
save('./S11D/Graph_analysis_NewGroups_Division_original_ch_order/rt_sw_coefW_groups.mat','rt_sw_coefW_groups');
save('./S11D/Graph_analysis_NewGroups_Division_original_ch_order/rtPos_sw_coefW_groups.mat','rtPos_sw_coefW_groups');

%% Bench 

%swi
bench3i_swi_groups = [bench3iswi_e , bench3iswi_b , bench3iswi_r];
bench3f_swi_groups = [bench3f_swi_e , bench3f_swi_b , bench3f_swi_r];

%sw_coef
bench3i_sw_coef_groups = [bench3isw_coef_e , bench3isw_coef_b , bench3isw_coef_r];
bench3f_sw_coef_groups = [bench3fsw_coef_e , bench3fsw_coef_b , bench3fsw_coef_r];

%sw_coefE
bench3i_sw_coefE_groups = [benchsw3i_coefE_e , benchsw3i_coefE_b , benchsw3i_coefE_r];
bench3f_sw_coefE_groups = [bench3f_sw_coefE_e , bench3f_sw_coefE_b , bench3f_sw_coefE_r];

%sw_coefW
benchsw3i_coefW_groups = [benchsw3i_coefW_e , benchsw3i_coefW_b , benchsw3i_coefW_r];
benchsw3f_coefW_groups = [benchsw3f_coefW_e , benchsw3f_coefW_b , benchsw3f_coefW_r];

save('./S11D/Graph_analysis_NewGroups_Division_original_ch_order/bench3i_swi_groups.mat','bench3i_swi_groups');
save('./S11D/Graph_analysis_NewGroups_Division_original_ch_order/bench3f_swi_groups.mat','bench3f_swi_groups');
save('./S11D/Graph_analysis_NewGroups_Division_original_ch_order/bench3i_sw_coef_groups.mat','bench3i_sw_coef_groups');
save('./S11D/Graph_analysis_NewGroups_Division_original_ch_order/bench3f_sw_coef_groups.mat','bench3f_sw_coef_groups');
save('./S11D/Graph_analysis_NewGroups_Division_original_ch_order/bench3i_sw_coefE_groups.mat','bench3i_sw_coefE_groups');
save('./S11D/Graph_analysis_NewGroups_Division_original_ch_order/bench3f_sw_coefE_groups.mat','bench3f_sw_coefE_groups');
save('./S11D/Graph_analysis_NewGroups_Division_original_ch_order/benchsw3i_coefW_groups.mat','benchsw3i_coefW_groups');
save('./S11D/Graph_analysis_NewGroups_Division_original_ch_order/benchsw3f_coefW_groups.mat','benchsw3f_coefW_groups');