export const idlFactory = ({ IDL }) => {
  return IDL.Service({ 'calculate' : IDL.Func([IDL.Text], [IDL.Text], []) });
};
export const init = ({ IDL }) => { return []; };
